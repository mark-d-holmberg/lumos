LumosApi =
  # Do an AJAX request to get the list of districts for this state
  GetDistricts: (state_abbr) ->
    # Get the URL
    $districts_api_url = $("form#campaign_search_form select#search_state").data("url")

    # Find the districts element
    $district_element = $("form#campaign_search_form select#search_district")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $districts_api_url
      data:
        state_abbr: state_abbr,
      dataType: "json"
      success: (data) ->
        # If we have data, then loop over it and put it in the form
        if data.length
          # Add each one
          $.each data, (index, element) ->
            $district_element.append($('<option>').text(element.name).attr('value', element.id));
          # Remove the disabled
          $district_element.prop('disabled', false)

  # Do an AJAX request to get the list of schools for this district
  GetSchools: (district_id) ->
    console.log("district_id is: ", district_id)

    # Get the URL
    $schools_api_string = $("form#campaign_search_form select#search_district").data("url")
    $schools_api_url = $schools_api_string.replace(/\:district_id/, district_id)

    # Find the districts element
    $school_element = $("form#campaign_search_form select#search_school")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $schools_api_url
      data:
        district_id: district_id,
      dataType: "json"
      success: (data) ->
        # If we have data, then loop over it and put it in the form
        if data.length
          # Add each one
          $.each data, (index, element) ->
            $school_element.append($('<option>').text(element.name).attr('value', element.id));
          # Remove the disabled
          $school_element.prop('disabled', false)


# Bind all the actual event handlers
jQuery ->
  # Bind the Public campaign search form state dropdown
  $("form#campaign_search_form select#search_state").change ->
    # Find the selected option
    $state_option = $(this).find("option:selected")

    # Find the next dropdown
    $district_element = $("form#campaign_search_form select#search_district")

    # Disable the district one
    $district_element.prop('disabled', true)

    # Clear out whatever is there
    $district_element.html('<option value="">Select a District</option>')

    # Make sure we have that HTML element
    if $state_option
      # See if there's actually a value
      $state_option_value = $state_option.val()

      # Make sure we're not on the blank option
      if $state_option_value.length
        LumosApi.GetDistricts($state_option_value)

  # Bind the Public camapign search form districts dropdown
  $("form#campaign_search_form select#search_district").change ->
    # Find the selected option
    $district_option = $(this).find("option:selected")

    # Find the next dropdown
    $school_element = $("form#campaign_search_form select#search_school")

    # Disable the district one
    $school_element.prop('disabled', true)

    # Clear out whatever is there
    $school_element.html('<option value="">Select a School</option>')

    # Make sure we have that HTML element
    if $district_option
      # See if there's actually a value
      $district_option_value = $district_option.val()

      # Make sure we're not on the blank option
      if $district_option_value.length
        LumosApi.GetSchools($district_option_value)

  # TODO: get the schools campaigns and what not
