jQuery ->

  # Do stuff when they change the State on Reassign Teacher
  $('form#reassign_teacher select#reassign_state_id').change (e) ->
    $state_option = $(this).find("option:selected")

    # Make sure we have that HTML element
    if $state_option
      # See if there's actually a value
      $state_abbr = $state_option.data("abbr")
      if $state_abbr.length
        # Get the URL
        $districts_api_url = $("form#reassign_teacher select#reassign_state_id").data("url")

        # Find the districts element
        $district_element = $("form#reassign_teacher select#reassign_district_id")

        # Do the actual ajax request
        $request = $.ajax
          type: "GET"
          url: $districts_api_url
          data:
            state_abbr: $state_abbr
          dataType: "json"
          success: (data) ->
            # If we have data, then loop over it and put it in the form
            if data.length
              # Add each one
              $.each data, (index, element) ->
                $district_element.append($('<option>').text(element.name).attr('value', element.id));

              # Remove the disabled
              $district_element.prop('disabled', false)

  # Do stuff when they change the District on Reassign Teacher
  $("form#reassign_teacher select#reassign_district_id").change (e) ->
    # Find the selected option
    $district_option = $(this).find("option:selected")
    $district_id = $district_option.val()

    # Make sure we have that HTML element
    if $district_option
      # See if there's actually a value
      $district_option_value = $district_option.val()

      # Make sure we're not on the blank option
      if $district_option_value.length
        # Get the URL
        $schools_api_string = $("form#reassign_teacher select#reassign_district_id").data("url")
        $schools_api_url = $schools_api_string.replace(/\:district_id/, $district_id)

        # Find the schools element
        $school_element = $("form#reassign_teacher select#reassign_new_school_id")

        # Do the actual ajax request
        $request = $.ajax
          type: "GET"
          url: $schools_api_url
          dataType: "json"
          success: (data) ->
            # If we have data, then loop over it and put it in the form
            if data.length
              # Add each one
              $.each data, (index, element) ->
                $school_element.append($('<option>').text(element.name).attr('value', element.id));
              # Remove the disabled
              $school_element.prop('disabled', false)
