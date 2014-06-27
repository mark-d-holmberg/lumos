LumosApi =
  ResetDistricts: ->
    $district_element = $("form#landing_new_campaign_form select#campaign_district_id")
    $district_element.html('<option value="">Select a District</option>')
    $district_element.prop('disabled', true)

  ResetSchools: ->
    $school_element = $("form#landing_new_campaign_form select#campaign_school_id")
    $school_element.html('<option value="">Select a School</option>')
    $school_element.prop('disabled', true)

  ResetCampaigns: ->
    $campaign_element = $("form#landing_new_campaign_form select#campaign_campaignable")
    $campaign_element.html('<option value="">Select a Campaignable</option>')
    $campaign_element.prop('disabled', true)

 # Do an AJAX request to get the list of districts for this state
  GetDistricts: (state_abbr) ->
    console.log("state_abbr is: ", state_abbr)
    # Get the URL
    $districts_api_url = $("form#landing_new_campaign_form select#campaign_state_id").data("url")

    # Find the districts element
    $district_element = $("form#landing_new_campaign_form select#campaign_district_id")

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
          # Reset the dropdown
          LumosApi.ResetDistricts()
          LumosApi.ResetSchools()
          LumosApi.ResetCampaigns()

          # Add each one
          $.each data, (index, element) ->
            $district_element.append($('<option>').text(element.name).attr('value', element.id));

          # Remove the disabled
          $district_element.prop('disabled', false)

  # Do an AJAX request to get the list of schools for this district
  GetSchools: (district_id) ->
    # Get the URL
    $schools_api_string = $("form#landing_new_campaign_form select#campaign_district_id").data("url")
    $schools_api_url = $schools_api_string.replace(/\:district_id/, district_id)

    # Find the schools element
    $school_element = $("form#landing_new_campaign_form select#campaign_school_id")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $schools_api_url
      dataType: "json"
      success: (data) ->
        # If we have data, then loop over it and put it in the form
        if data.length
          # Reset the dropdowns
          LumosApi.ResetSchools()
          LumosApi.ResetCampaigns()

          # Add each one
          $.each data, (index, element) ->
            $school_element.append($('<option>').text(element.name).attr('value', element.id));
          # Remove the disabled
          $school_element.prop('disabled', false)

jQuery ->
  # Bind the stuff for creating a new campaign
  $("form#landing_new_campaign_form select#campaign_state_id").change ->
    # Find the selected option
    $state_option = $(this).find("option:selected")

    # Make sure we have that HTML element
    if $state_option
      # See if there's actually a value
      $state_option_value = $state_option.data("abbr")

      # Make sure we're not on the blank option
      if $state_option_value.length
        LumosApi.GetDistricts($state_option_value)

  # Bind the stuff for creating a new campaign
  $("form#landing_new_campaign_form select#campaign_district_id").change ->
    # Find the selected option
    $district_option = $(this).find("option:selected")

    # Make sure we have that HTML element
    if $district_option
      # See if there's actually a value
      $district_option_value = $district_option.val()

      # Make sure we're not on the blank option
      if $district_option_value.length
        LumosApi.GetSchools($district_option_value)

