class ZCL_CORE_TVARVC definition
  public
  create public .

public section.

  interfaces ZIF_CORE_TVARVC .

  methods CONSTRUCTOR
    importing
      !IO_TVARVC_DB type ref to ZIF_CORE_TVARVC_DB optional .
  class-methods DEMO_TESTER .
protected section.
private section.

  data MO_TVARVC_DB type ref to ZIF_CORE_TVARVC_DB .
ENDCLASS.



CLASS ZCL_CORE_TVARVC IMPLEMENTATION.


  METHOD constructor.

    IF io_tvarvc_db IS BOUND.
      mo_tvarvc_db = io_tvarvc_db.
    ELSE.
      CREATE OBJECT mo_tvarvc_db TYPE zcl_core_tvarvc_db.
    ENDIF.

  ENDMETHOD.


  METHOD zif_core_tvarvc~read_parameter.

    DATA ls_tvarvc_entry TYPE tvarvc.

    ls_tvarvc_entry = mo_tvarvc_db->find_by_id( iv_name ).

    IF ls_tvarvc_entry IS NOT INITIAL.
      MOVE-CORRESPONDING ls_tvarvc_entry TO result.

    ELSE.
      RAISE EXCEPTION TYPE zcx_core_tvarvc
        EXPORTING
          textid         = zcx_core_tvarvc=>missing_entry
          mv_tvarvc_name = iv_name.
    ENDIF.

  ENDMETHOD.


  METHOD zif_core_tvarvc~read_select_options.

    DATA lt_tvarvc_entries TYPE TABLE OF string.
    DATA ls_tvarvc_entry   TYPE tvarvc.
    DATA ls_params         TYPE rsparams.

    FIELD-SYMBOLS <fs_tvarvc_value> TYPE any.

    ls_tvarvc_entry = mo_tvarvc_db->find_by_id( iv_name ).

    IF ls_tvarvc_entry IS NOT INITIAL.
      SPLIT ls_tvarvc_entry-low AT iv_separator INTO TABLE lt_tvarvc_entries.

      LOOP AT lt_tvarvc_entries ASSIGNING <fs_tvarvc_value>.
        MOVE-CORRESPONDING ls_tvarvc_entry TO ls_params.

        ls_params-sign   = 'I'.
        ls_params-option = 'EQ'.
        ls_params-low    = <fs_tvarvc_value>.

        APPEND ls_params TO result.
      ENDLOOP.

    ELSE.
      RAISE EXCEPTION TYPE zcx_core_tvarvc
        EXPORTING
          textid         = zcx_core_tvarvc=>missing_entry
          mv_tvarvc_name = iv_name.
    ENDIF.

  ENDMETHOD.


  METHOD zif_core_tvarvc~read_select_options_tab.

    DATA lt_tvarvc_entries TYPE zcore_tvarvc_tab.
    DATA ls_params         TYPE rsparams.

    FIELD-SYMBOLS <fs_tvarvc_entries> TYPE tvarvc.

    lt_tvarvc_entries = mo_tvarvc_db->find_all_by_id( iv_name ).

    IF lt_tvarvc_entries IS NOT INITIAL.

      LOOP AT lt_tvarvc_entries ASSIGNING <fs_tvarvc_entries>.
        MOVE-CORRESPONDING <fs_tvarvc_entries> TO ls_params.
        ls_params-option  = <fs_tvarvc_entries>-opti.
        ls_params-selname = <fs_tvarvc_entries>-name.
        ls_params-kind    = <fs_tvarvc_entries>-type.

        APPEND ls_params TO result.
      ENDLOOP.

    ELSE.
      RAISE EXCEPTION TYPE zcx_core_tvarvc
        EXPORTING
          textid         = zcx_core_tvarvc=>missing_entry
          mv_tvarvc_name = iv_name.
    ENDIF.

  ENDMETHOD.


  METHOD DEMO_TESTER.


*   From transaction STVARV is possible create/modify
*
*   parameters like Z_TEST_TVARVC_PARAMETER
*               or  Z_TEST_TVARVC_PERNR

    DATA go_tvarvc TYPE REF TO zif_core_tvarvc ##NEEDED.
    DATA gx_tvarvc TYPE REF TO zcx_core_tvarvc ##NEEDED.
    DATA gs_tvarvc TYPE rsparams ##NEEDED.

    DATA lr_pernr TYPE RANGE OF pernr.

    DATA lv_text TYPE char100.

    CONSTANTS gc_tvarvc_entry TYPE string VALUE 'Z_TEST_TVARVC_PARAMETER'.

    CREATE OBJECT go_tvarvc TYPE zcl_core_tvarvc.

    TRY.
        gs_tvarvc = go_tvarvc->read_parameter( gc_tvarvc_entry ).
        WRITE /: |Read Parameter: { gs_tvarvc-low }| ##NO_TEXT.


        CALL METHOD go_tvarvc->get_parameter
          EXPORTING
            iv_name      = gc_tvarvc_entry
*           iv_separator = ''
          IMPORTING
            ov_parameter = lv_text.
        WRITE /: |GET  Parameter: { lv_text }| ##NO_TEXT.


        CALL METHOD go_tvarvc->get_range
          EXPORTING
            iv_name      = 'Z_TEST_TVARVC_PERNR'
            iv_separator = ';'
          IMPORTING
            or_result    = lr_pernr.




      CATCH zcx_core_tvarvc INTO gx_tvarvc.
        gx_tvarvc->raise_message( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_core_tvarvc~get_parameter.

    FIELD-SYMBOLS:
                   <lv_value>    TYPE any
                   .

    ASSIGN ov_parameter TO <lv_value>.

    DATA ls_tvarvc_entry TYPE tvarvc.

    ls_tvarvc_entry = mo_tvarvc_db->find_by_id( iv_name ).

    IF ls_tvarvc_entry IS NOT INITIAL.
      MOVE ls_tvarvc_entry-low TO <lv_value>.

      IF ls_tvarvc_entry-high IS NOT INITIAL.
        CONCATENATE <lv_value> ls_tvarvc_entry-high INTO <lv_value>.
      ENDIF.
    ELSE.
      RAISE EXCEPTION TYPE zcx_core_tvarvc
        EXPORTING
          textid         = zcx_core_tvarvc=>missing_entry
          mv_tvarvc_name = iv_name.
    ENDIF.

  ENDMETHOD.


  METHOD zif_core_tvarvc~get_range.


    DATA lt_entries TYPE TABLE OF string.
    DATA ls_entry LIKE LINE OF lt_entries.

    DATA lt_tvarvc_entries TYPE zcore_tvarvc_tab.
    DATA ls_tvarvc_entry   LIKE LINE OF lt_tvarvc_entries.

    DATA lv_separator LIKE iv_separator.
    DATA lo_dynamic_line TYPE REF TO data.
    DATA lv_string TYPE string.

    FIELD-SYMBOLS:
                  <lt_ev_range> TYPE table
                 ,<ls_ev_range> TYPE any
                 ,<lv_value>    TYPE any
                    .

    lv_separator = iv_separator.
    lv_separator = condense( lv_separator ).

    IF ( lv_separator EQ '' OR lv_separator EQ ' '  ).
      CLEAR lv_separator.
    ENDIF.

    lt_tvarvc_entries = mo_tvarvc_db->find_all_by_id( iv_name ).

    IF lt_tvarvc_entries IS NOT INITIAL.


      ASSIGN or_result TO <lt_ev_range>.
      CREATE DATA lo_dynamic_line LIKE LINE OF <lt_ev_range>.

      ASSIGN lo_dynamic_line->* TO <ls_ev_range>.



      LOOP AT lt_tvarvc_entries INTO ls_tvarvc_entry.

        CLEAR <ls_ev_range>.

        IF ( ls_tvarvc_entry-sign IS INITIAL ).
          ls_tvarvc_entry-sign = 'I'.
        ENDIF.

        ASSIGN COMPONENT 1 OF STRUCTURE <ls_ev_range> TO <lv_value>.
        <lv_value> = ls_tvarvc_entry-sign. "'I'.


        IF ( ls_tvarvc_entry-opti IS INITIAL ).
          ls_tvarvc_entry-opti = 'EQ'.
        ENDIF.

        ASSIGN COMPONENT 2 OF STRUCTURE <ls_ev_range> TO <lv_value>.
        IF ( lv_string CS '*' ).
          <lv_value> = 'CP'.
        ELSE.
          <lv_value> = ls_tvarvc_entry-opti. "'EQ'.
        ENDIF.


        IF ( lv_separator IS NOT INITIAL ).
          CLEAR: lt_entries, lt_entries[].
          SPLIT ls_tvarvc_entry-low AT lv_separator INTO TABLE lt_entries.

          LOOP AT lt_entries INTO ls_entry.

            ASSIGN COMPONENT 2 OF STRUCTURE <ls_ev_range> TO <lv_value>.
            IF ( ls_entry CS '*' ).
              <lv_value> = 'CP'.
            ELSE.
              <lv_value> = ls_tvarvc_entry-opti. "'EQ'.
            ENDIF.


            ASSIGN COMPONENT 3 OF STRUCTURE <ls_ev_range> TO <lv_value>.
            <lv_value> = ls_entry.

            APPEND <ls_ev_range> TO <lt_ev_range>.
          ENDLOOP.

        ELSE.

          ASSIGN COMPONENT 3 OF STRUCTURE <ls_ev_range> TO <lv_value>.
          <lv_value> = ls_tvarvc_entry-low.

          IF ( ls_tvarvc_entry-high IS NOT INITIAL ).
            ASSIGN COMPONENT 4 OF STRUCTURE <ls_ev_range> TO <lv_value>.
            <lv_value> = ls_tvarvc_entry-high.
          ENDIF.

          APPEND <ls_ev_range> TO <lt_ev_range>.
        ENDIF.

      ENDLOOP.

    ELSE.
      RAISE EXCEPTION TYPE zcx_core_tvarvc
        EXPORTING
          textid         = zcx_core_tvarvc=>missing_entry
          mv_tvarvc_name = iv_name.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
