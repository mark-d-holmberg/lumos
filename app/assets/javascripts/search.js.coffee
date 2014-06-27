LumosApi =
  ResetDistricts: ->
    $district_element = $("form#campaign_search_form select#search_district")
    $district_element.html('<option value="">Select a District</option>')
    $district_element.prop('disabled', true)

  ResetSchools: ->
    $school_element = $("form#campaign_search_form select#search_school")
    $school_element.html('<option value="">Select a School</option>')
    $school_element.prop('disabled', true)

  ResetCampaigns: ->
    $campaign_element = $("form#campaign_search_form select#search_campaignable")
    $campaign_element.html('<option value="">Select a Campaign</option>')
    $campaign_element.prop('disabled', true)

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
        scoped: true,
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
    $schools_api_string = $("form#campaign_search_form select#search_district").data("url")
    $schools_api_url = $schools_api_string.replace(/\:district_id/, district_id)

    # Find the schools element
    $school_element = $("form#campaign_search_form select#search_school")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $schools_api_url
      data:
        scoped: true
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

  # Do an AJAX request to get the list of schools for this district
  GetCampaigns: (district_id, school_id) ->
    # Get the URL
    $campaigns_api_string = $("form#campaign_search_form select#search_school").data("url")
    $campaigns_api_url = $campaigns_api_string.replace(/\:district_id/, district_id).replace(/\:school_id/, school_id)

    # Find the campaigns element
    $campaign_element = $("form#campaign_search_form select#search_campaignable")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $campaigns_api_url
      dataType: "json"
      success: (data) ->
        # If we have data, then loop over it and put it in the form
        if data.length
          # Reset the dropdowns
          LumosApi.ResetCampaigns()

          # TODO: have this filter out the single school based campaign,
          # From the many teacher based campaigns

          # TODO: require the email

          # Add each one
          $.each data, (index, element) ->
            $campaign_element.append($('<option>').text(element.name).attr('value', element.permalink));
          # Remove the disabled
          $campaign_element.prop('disabled', false)

  # Now that we have a campaign, redirect to the page for it.
  RedirectToCampaign: (permalink) ->
    # Get the actual permalink and inform the landing page that
    # we are syndicated through searching
    $my_landing_url = permalink + '?synd=search'

    # Redirect to the landing page for this campaign
    window.location.href = $my_landing_url

# Bind all the actual event handlers
jQuery ->
  # Bind the Public campaign search form state dropdown
  $("form#campaign_search_form select#search_state").change ->
    # Find the selected option
    $state_option = $(this).find("option:selected")

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

    # Make sure we have that HTML element
    if $district_option
      # See if there's actually a value
      $district_option_value = $district_option.val()

      # Make sure we're not on the blank option
      if $district_option_value.length
        LumosApi.GetSchools($district_option_value)

  # Bind the Public camapign search form schools dropdown
  $("form#campaign_search_form select#search_school").change ->
    # Find the district option
    $district_option = $("form#campaign_search_form select#search_district option:selected")

    # Find the selected option
    $school_option = $(this).find("option:selected")

    # Make sure we have that HTML element
    if $school_option && $district_option
      # See if there's actually a value
      $district_option_value = $district_option.val()
      $school_option_value = $school_option.val()

      # Make sure we're not on the blank option
      if $school_option_value.length and $district_option_value.length
        LumosApi.GetCampaigns($district_option_value, $school_option_value)

  # Bind the Public campaign search form Campaigns dropdown
  $("form#campaign_search_form select#search_campaignable").change ->
    $campaign_option = $(this).find("option:selected")

    if $campaign_option
      $campaign_option_value = $campaign_option.val()
      if $campaign_option_value.length
        # Do the call
        LumosApi.RedirectToCampaign($campaign_option_value)
