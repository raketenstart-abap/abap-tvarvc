*&---------------------------------------------------------------------*
*& Report Z_TEST_TVARVC_PARAMETER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_tvarvc_parameter.

DATA go_tvarvc TYPE REF TO zif_core_tvarvc ##NEEDED.
DATA gx_tvarvc TYPE REF TO zcx_core_tvarvc ##NEEDED.
DATA gs_tvarvc TYPE rsparams ##NEEDED.

CONSTANTS gc_tvarvc_entry TYPE string VALUE 'Z_TEST_TVARVC_PARAMETER'.

CREATE OBJECT go_tvarvc TYPE zcl_core_tvarvc.

TRY.
    gs_tvarvc = go_tvarvc->read_parameter( gc_tvarvc_entry ).
    WRITE /: |Parameter: { gs_tvarvc-low }| ##NO_TEXT.

  CATCH zcx_core_tvarvc INTO gx_tvarvc.
    gx_tvarvc->raise_message( ).
ENDTRY.
