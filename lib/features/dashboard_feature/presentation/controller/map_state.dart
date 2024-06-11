enum MapState {
  INITIAL_STATE,
  BOOKING_ARRIVED,
  ACCEPT_BOOKING_STATE,
  PICKUP_BOOKING_STATE,
  NEGOTIATION_BOOKING_STATE,
  REQUEST_CUSTOMER_OTP_FOR_RIDE_START_STATE,
  LOADER_STATE,
  VERIFIED_OTP_AND_RIDE_START_STATE,
  REASON_TO_CANCEL_RIDE,
  WANT_TO_CANCEL_RIDE_STATE,
  REACHED_TO_DESTINATION,
  TRIP_COMPLETE
}