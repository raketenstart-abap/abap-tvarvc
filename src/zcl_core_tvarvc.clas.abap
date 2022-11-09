class ZCL_CORE_TVARVC definition
  public
  create public .

public section.

  interfaces ZIF_CORE_TVARVC .

  methods CONSTRUCTOR
    importing
      !IO_TVARVC_DB type ref to ZIF_CORE_TVARVC_DB optional .
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
ENDCLASS.
