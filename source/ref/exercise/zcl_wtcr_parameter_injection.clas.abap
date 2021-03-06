CLASS zcl_wtcr_parameter_injection DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_amount_in_coins
      IMPORTING i_amount        TYPE i
                i_cash_provider TYPE REF TO zif_wtcr_cash_provider OPTIONAL "parameter injection
      RETURNING VALUE(r_value)  TYPE i.
    METHODS get_amount_in_notes
      IMPORTING i_amount        TYPE i
                i_cash_provider TYPE REF TO zif_wtcr_cash_provider OPTIONAL "parameter injection
      RETURNING VALUE(r_value)  TYPE i.
ENDCLASS.



CLASS zcl_wtcr_parameter_injection IMPLEMENTATION.


  METHOD get_amount_in_coins.
    DATA(cash_provider) = CAST zif_wtcr_cash_provider(
                            COND #( WHEN i_cash_provider IS BOUND
                                    THEN i_cash_provider  "parameter injection
                                    ELSE NEW zcl_wtcr_cash_provider( ) ) ).

    DATA(notes) = cash_provider->get_notes( i_currency = 'EUR' ).
    SORT notes BY amount ASCENDING.

    r_value = COND #( WHEN i_amount <= 0
                      THEN -1
                      ELSE i_amount MOD notes[ 1 ]-amount ).
  ENDMETHOD.


  METHOD get_amount_in_notes.
    r_value = get_amount_in_coins( i_amount = i_amount
                                   i_cash_provider = i_cash_provider ). "parameter injection
    IF r_value >= 0.
      r_value = i_amount - r_value.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
