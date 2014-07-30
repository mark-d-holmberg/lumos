jQuery ->

  # Lock out the district_name when they select a district_id
  $("form#convert_campaign_request select#convert_campaign_request_associations_district_id").change (e) ->
    $district_option = $(this).find("option:selected");
    $school_element = $("form#convert_campaign_request select#convert_campaign_request_associations_school_id")

    if $district_option
      # Get a list of schools for the selected district
      $district_id = $district_option.val()

      if $district_id.length
        # Disable manual entry
        $("form#convert_campaign_request input#convert_campaign_request_district_name").prop('disabled', true)
        $school_element.prop('disabled', false)

        # Get the URL
        $schools_api_string = $("form#convert_campaign_request select#convert_campaign_request_associations_district_id").data("url")
        $schools_api_url = $schools_api_string.replace(/\:district_id/, $district_id)

        # Do the actual ajax request
        $request = $.ajax
          type: "GET"
          url: $schools_api_url
          dataType: "json"
          success: (data) ->
            # If we have data, then loop over it and put it in the form
            if data.length
              # Reset the data
              $school_element.html('<option value="">Select a School</option>')

              # Add each one
              $.each data, (index, element) ->
                $school_element.append($('<option>').text(element.name).attr('value', element.id));
              # Remove the disabled
              $school_element.prop('disabled', false)
      else
        # Clear out the override value for a school
        $school_element.html('<option value="">Select a School</option>')
        # Re-enable manual entry
        $("form#convert_campaign_request input#convert_campaign_request_district_name").prop('disabled', false)
        $school_element.prop('disabled', true)


  # Lock out the school_name when they select a school_id
  $("form#convert_campaign_request select#convert_campaign_request_associations_school_id").change (e) ->
    $school_option = $(this).find("option:selected");
    $teacher_element = $("form#convert_campaign_request select#convert_campaign_request_associations_teacher_id")

    if $school_option
      # Get a list of teachers for the selected school
      $school_id = $school_option.val()

      if $school_id.length
        # Disable manual entry
        $("form#convert_campaign_request input#convert_campaign_request_school_name").prop('disabled', true)
        $teacher_element.prop('disabled', false)

        # Get the URL
        $teacher_api_string = $("form#convert_campaign_request select#convert_campaign_request_associations_school_id").data("url")
        $teacher_api_url = $teacher_api_string.replace(/\:school_id/, $school_id)

        # Do the actual ajax request
        $request = $.ajax
          type: "GET"
          url: $teacher_api_url
          dataType: "json"
          success: (data) ->
            # If we have data, then loop over it and put it in the form
            if data.length
              # Reset the data
              $teacher_element.html('<option value="">Select a Teacher</option>')

              # Add each one
              $.each data, (index, element) ->
                $teacher_element.append($('<option>').text(element.prestigious_name).attr('value', element.id));
              # Remove the disabled
              $teacher_element.prop('disabled', false)
      else
        # Clear out the value for a teacher
        $teacher_element.html('<option value="">Select a Teacher</option>')
        # Re-enable manual entry
        $("form#convert_campaign_request input#convert_campaign_request_school_name").prop('disabled', false)
        $teacher_element.prop('disabled', true)

  # Lock out the teacher name when they select a teacher_id
  $("form#convert_campaign_request select#convert_campaign_request_associations_teacher_id").change (e) ->
    $teacher_option = $(this).find("option:selected");
    if $teacher_option
      $teacher_id = $teacher_option.val()
      $teacher_element = $("form#convert_campaign_request select#convert_campaign_request_associations_teacher_id")

      if $teacher_id.length
        $("form#convert_campaign_request input#convert_campaign_request_teacher_first_name").prop('disabled', true)
        $("form#convert_campaign_request input#convert_campaign_request_teacher_last_name").prop('disabled', true)

        # Disable manual entry
        $teacher_element.prop('disabled', false)
      else
        # Clear out the value for a teacher
        $teacher_element.html('<option value="">Select a Teacher</option>')
        # Re-enable manual entry
        $("form#convert_campaign_request input#convert_campaign_request_teacher_first_name").prop('disabled', false)
        $("form#convert_campaign_request input#convert_campaign_request_teacher_last_name").prop('disabled', false)
        $teacher_element.prop('disabled', true)
