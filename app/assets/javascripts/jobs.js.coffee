# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class RemoteWork.Jobs
  constructor: (jobsUrl, categoriesUrl)->
    @jobsUrl = jobsUrl
    @categoriesUrl = categoriesUrl
    $('.category-link').on 'click', @categoryClicked

  # categoryClicked: (e)=>
  #   $clicked = $(e.target)
  #   src = $clicked.data 'src'
  #   $.ajax
  #     'url': src
  #     'authenticity_token': $('meta[name="csrf-token"]').attr('content')
  #     'type': 'GET'
  #     'success': (data, textStatus, xhr)=>
  #       $('.job-list').html(data)
  #       @setActiveTab($clicked)
  #     'error': (xhr, textStatus, errorThrown)=>
  #
  # setActiveTab: ($clicked)=>
  #   href = $clicked.attr('href').substring(1)
  #   $('.navmenu-nav li').removeClass 'active'
  #   $('.navmenu-nav li.' + href).addClass 'active'

  initialize: ()->
    url = window.location.href
    category = url.substring(url.lastIndexOf('/') + 1)
    if category == 'jobs' || category == ''
      path = @jobsUrl
    else
      path = @categoriesUrl + '/' + category
    console.log 'path is ' + path
    $(".nav a[href='" + path + "']").trigger 'click'
