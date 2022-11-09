*&---------------------------------------------------------------------*
*& Report Z_TEST_TVARVC_SELECT_OPTIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_tvarvc_select_options.

DATA go_tvarvc TYPE REF TO zif_core_tvarvc ##NEEDED.
DATA gx_tvarvc TYPE REF TO zcx_core_tvarvc ##NEEDED.
DATA gt_tvarvc TYPE rsparams_tt ##NEEDED.
DATA gr_test   TYPE RANGE OF zdt_test ##NEEDED.

FIELD-SYMBOLS <fs_test> TYPE any ##NEEDED.

CONSTANTS gc_tvarvc_entry TYPE string VALUE 'Z_TEST_TVARVC_SELECT_OPTIONS'.

CREATE OBJECT go_tvarvc TYPE zcl_core_tvarvc.

TRY.
    gt_tvarvc = go_tvarvc->read_select_options( gc_tvarvc_entry ).
    MOVE-CORRESPONDING gt_tvarvc[] TO gr_test[].

    LOOP AT gr_test ASSIGNING <fs_test>.
      WRITE /: <fs_test>.
    ENDLOOP.

  CATCH zcx_core_tvarvc INTO gx_tvarvc.
    gx_tvarvc->raise_message( ).
ENDTRY.
