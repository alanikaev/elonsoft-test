# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setConstraints = (sgt, kladr_id) ->
  restrict_value = false
  locations = null
  if kladr_id
    locations = {kladr_id: kladr_id}
    restrict_value = true
  sgt.setOptions({
    constraints: {
      locations: locations
    },
    restrict_value: restrict_value
  })

enforceCity = (suggestion) ->
  sgt = $("#event_address").suggestions()
  sgt.clear()
  if suggestion
    setConstraints(sgt, suggestion.data.kladr_id)
  else
    setConstraints(sgt, null)

restrictAddressValue = (suggestion) ->
  citySgt = $("#event_city").suggestions();
  addressSgt = $("#event_address").suggestions();
  if !citySgt.currentValue
    citySgt.setSuggestion(suggestion);
    city_kladr_id = suggestion.data.kladr_id.substr(0, 13);
    setConstraints(addressSgt, city_kladr_id);

formatSelected = (suggestion) ->
  addressValue = makeAddressString(suggestion.data)
  return addressValue

makeAddressString = (address) ->
  return join([
    address.street_with_type,
    join([address.house_type, address.house,
      address.block_type, address.block], " "),
    join([address.flat_type, address.flat], " ")
  ])

join = (arr) ->
  if arguments.length > 1
    separator = arguments[1]
  else
    separator = ", "
  return arr.filter((n) -> return n).join(separator)

$(document).on('turbolinks:load', () ->
  $("#event_city").suggestions({
    serviceUrl: "https://dadata.ru/api/v2",
    token: "c671e732daf36f50df346898e098a33ed995599f",
    type: "ADDRESS",
    hint: false,
    bounds: "city",
    onSelect: enforceCity,
    onSelectNothing: enforceCity
  })

  $("#event_address").suggestions({
    serviceUrl: "https://dadata.ru/api/v2",
    token: "c671e732daf36f50df346898e098a33ed995599f",
    type: "ADDRESS",
    onSelect: restrictAddressValue
    formatSelected: formatSelected
  })

  $("#q_city_eq").suggestions({
    serviceUrl: "https://dadata.ru/api/v2",
    token: "c671e732daf36f50df346898e098a33ed995599f",
    type: "ADDRESS",
    hint: false,
    bounds: "city",
    onSelect: enforceCity,
    onSelectNothing: enforceCity
  })

  $("#q_address_eq").suggestions({
    serviceUrl: "https://dadata.ru/api/v2",
    token: "c671e732daf36f50df346898e098a33ed995599f",
    type: "ADDRESS",
    onSelect: restrictAddressValue
    formatSelected: formatSelected
  })
)