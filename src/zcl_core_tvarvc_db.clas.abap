class ZCL_CORE_TVARVC_DB definition
  public
  create public .

public section.

  interfaces ZIF_CORE_TVARVC_DB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CORE_TVARVC_DB IMPLEMENTATION.


  METHOD zif_core_tvarvc_db~find_all_by_id.

    SELECT *
      FROM tvarvc
      INTO TABLE result
      WHERE name = iv_name.

  ENDMETHOD.


  METHOD zif_core_tvarvc_db~find_by_id.

    SELECT SINGLE *
      FROM tvarvc
      INTO result
      WHERE name = iv_name.

  ENDMETHOD.
ENDCLASS.
