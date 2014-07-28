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
    $campaign_element = $("form#landing_new_campaign_form select#campaign_campaignable_id")
    $campaign_element.html('<option value="">Select a Teacher/School</option>')
    $campaign_element.prop('disabled', true)

 # Do an AJAX request to get the list of districts for this state
  GetDistricts: (state_abbr) ->
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

          # Add a 'Not Listed' step
          $district_element.append($('<option>').text("District Not Listed").attr('value', '-1'));

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

  # Do an AJAX request to get the list of schools for this district
  GetCampaigns: (district_id, school_id, campaignable_type) ->
    # Get the URL
    $campaigns_api_string = $("form#landing_new_campaign_form select#campaign_school_id").data("url")
    $campaigns_api_url = $campaigns_api_string.replace(/\:district_id/, district_id).replace(/\:school_id/, school_id)

    # Update the new teacher link
    $new_teacher_link = $("a#new_teacher_link")
    $new_url = $new_teacher_link.attr("href").replace(/\:school_id/, school_id)
    $new_teacher_link.removeAttr("disabled").attr("href", $new_url)

    # Find the campaigns element
    $campaign_type_element = $("form#landing_new_campaign_form select#campaign_campaignable_type")
    $campaigns_element = $("form#landing_new_campaign_form select#campaign_campaignable_id")
    $school_element = $("form#landing_new_campaign_form select#campaign_school_id option:selected")

    # Do the actual ajax request
    $request = $.ajax
      type: "GET"
      url: $campaigns_api_url
      data:
        campaignable_type: campaignable_type
      dataType: "json"
      success: (data) ->
        # If we have data, then loop over it and put it in the form
        if data
          # Reset the dropdowns
          LumosApi.ResetCampaigns()

          if campaignable_type is 'School'
            # Forward them to the actual campaign
            $my_landing_url = data.permalink + '?synd=redirect'

            # Redirect to the landing page for this campaign
            window.location.href = $my_landing_url
          else
            # Teacher based campaigns

            # Remove the disabled
            $campaigns_element.prop('disabled', false)

            # Add each one
            if data.length
              $.each data, (index, element) ->
                if element.permalink
                  # Append the permalink to the data attribute for this entry
                  $campaigns_element.append($('<option>').text(element.prestigious_name).attr('value', element.id).data("permalink", element.permalink));
                else
                  $campaigns_element.append($('<option>').text(element.prestigious_name).attr('value', element.id));
        else
          # Copy the school over
          if campaignable_type is 'School'
            $campaigns_element.append($('<option>').text($school_element.text()).attr('value', school_id));
            $campaigns_element.prop('disabled', false)
          else
            console.log("no data was returned")

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

      if $district_option_value is '-1'
        window.location = $(this).data("new-campaign-request-url")
      else
        # Make sure we're not on the blank option
        if $district_option_value.length
          LumosApi.GetSchools($district_option_value)


  # Bind the stuff for creating a new campaign
  $("form#landing_new_campaign_form select#campaign_campaignable_type").change ->
    # Find the district option
    $district_option = $("form#landing_new_campaign_form select#campaign_district_id option:selected")
    $school_option = $("form#landing_new_campaign_form select#campaign_school_id option:selected")

    # Find the selected option
    $campaignable_type_option = $(this).find("option:selected")

    # Make sure we have that HTML element
    if $campaignable_type_option && $district_option && $school_option
      $campaignable_type_option_value = $campaignable_type_option.val()

      # See if there's actually a value
      $district_option_value = $district_option.val()
      $school_option_value = $school_option.val()

      # Make sure we're not on the blank option
      if $school_option_value.length and $district_option_value.length
        LumosApi.GetCampaigns($district_option_value, $school_option_value, $campaignable_type_option_value)

  # Bind the stuff for creating a new campaign
  $("form#landing_new_campaign_form select#campaign_campaignable_id").change ->
    # Find the selected option
    $teacher_option = $(this).find("option:selected")
    $permalink = $teacher_option.data("permalink")

    if $permalink
      # Forward them to the actual campaign
      $my_landing_url = $permalink + '?synd=redirect'

      # Redirect to the landing page for this campaign
      window.location.href = $my_landing_url
    else
      # Do nothing
