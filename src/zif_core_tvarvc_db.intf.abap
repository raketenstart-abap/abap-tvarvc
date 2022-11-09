interface ZIF_CORE_TVARVC_DB
  public .


  methods FIND_BY_ID
    importing
      !IV_NAME type STRING
    returning
      value(RESULT) type TVARVC .
  methods FIND_ALL_BY_ID
    importing
      !IV_NAME type STRING
    returning
      value(RESULT) type ZCORE_TVARVC_TAB .
endinterface.
