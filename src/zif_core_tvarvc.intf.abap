interface ZIF_CORE_TVARVC
  public .


  methods READ_PARAMETER
    importing
      !IV_NAME type STRING
    returning
      value(RESULT) type RSPARAMS
    raising
      ZCX_CORE_TVARVC .
  methods READ_SELECT_OPTIONS
    importing
      !IV_NAME type STRING
      !IV_SEPARATOR type STRING default ','
    returning
      value(RESULT) type RSPARAMS_TT
    raising
      ZCX_CORE_TVARVC .
  methods READ_SELECT_OPTIONS_TAB
    importing
      !IV_NAME type STRING
    returning
      value(RESULT) type RSPARAMS_TT
    raising
      ZCX_CORE_TVARVC .
  methods GET_RANGE
    importing
      !IV_NAME type STRING
      !IV_SEPARATOR type STRING default ','
    exporting
      value(OR_RESULT) type TABLE
    raising
      ZCX_CORE_TVARVC .
  methods GET_PARAMETER
    importing
      !IV_NAME type STRING
    exporting
      value(OV_PARAMETER) type ANY
    raising
      ZCX_CORE_TVARVC .
endinterface.
