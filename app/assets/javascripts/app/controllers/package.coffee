class Index extends App.ControllerContent
  events:
    'click .action':  'action'

  constructor: ->
    super

    # check authentication
    return if !@authenticate()

    @title 'Packages', true

    @load()

  load: ->
    @ajax(
      id:    'packages',
      type:  'GET',
      url:   "#{@apiPath}/packages",
      processData: true,
      success: (data) =>
        @packages = data
        @render()
      )

  render: ->

    for item in @packages
      item.action = []
      if item.state == 'installed'
#        item.action = ['uninstall', 'deactivate']
        item.action = ['uninstall']
      else if item.state == 'uninstalled'
        item.action = ['install']
      else if item.state == 'deactivate'
        item.action = ['uninstall', 'activate']

    @html App.view('package')(
      head:     'Dashboard'
      packages: @packages
    )

  action: (e) ->
    e.preventDefault()
    id = $(e.target).parents('[data-id]').data('id')
    type = $(e.target).data('type')
    if type is 'uninstall'
      httpType = 'DELETE'

    if httpType
      @ajax(
        id:    'packages'
        type:  httpType
        url:   "#{@apiPath}/packages",
        data:  JSON.stringify( { id: id } )
        processData: false
        success: =>
          @load()
        )

App.Config.set( 'Packages', { prio: 1000, name: 'Packages', parent: '#system', target: '#system/package', controller: Index, role: ['Admin'] }, 'NavBarAdmin' )
