class ZCX_CORE_TVARVC definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of MISSING_ENTRY,
      msgid type symsgid value 'ZCORE_TVARVC',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'MV_TVARVC_NAME',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MISSING_ENTRY .
  data MV_TVARVC_NAME type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MV_TVARVC_NAME type STRING optional .
  methods BUILD_BAPIRET
    returning
      value(RESULT) type BAPIRET2 .
  methods RAISE_MESSAGE
    importing
      !IV_MSGTY type SYMSGTY default 'E' .
protected section.
PRIVATE SECTION.

  ALIASES t100key
    FOR if_t100_message~t100key .

  CONSTANTS:
    BEGIN OF sc_msgty,
      abort   TYPE symsgty VALUE 'A',
      error   TYPE symsgty VALUE 'E',
      exit    TYPE symsgty VALUE 'X',
      info    TYPE symsgty VALUE 'I',
      success TYPE symsgty VALUE 'S',
      warning TYPE symsgty VALUE 'W',
    END OF sc_msgty .
ENDCLASS.



CLASS ZCX_CORE_TVARVC IMPLEMENTATION.


  METHOD build_bapiret.

    IF t100key IS INITIAL.
      RETURN.
    ENDIF.

    cl_message_helper=>set_msg_vars_for_if_t100_msg( me ).

    MESSAGE ID t100key-msgid
          TYPE sc_msgty-error
        NUMBER t100key-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
          INTO result-message.

    result-id         = t100key-msgid.
    result-type       = sy-msgty.
    result-number     = sy-msgno.
    result-message_v1 = sy-msgv1.
    result-message_v2 = sy-msgv2.
    result-message_v3 = sy-msgv3.
    result-message_v4 = sy-msgv4.

  ENDMETHOD.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MV_TVARVC_NAME = MV_TVARVC_NAME .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  METHOD raise_message.

    IF t100key IS INITIAL.
      RETURN.
    ENDIF.

    cl_message_helper=>set_msg_vars_for_if_t100_msg( me ).

    MESSAGE ID t100key-msgid
          TYPE sc_msgty-success
        NUMBER t100key-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
  DISPLAY LIKE iv_msgty.

  ENDMETHOD.
ENDCLASS.
