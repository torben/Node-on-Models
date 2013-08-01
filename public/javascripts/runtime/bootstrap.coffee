namespace 'runtime'

$ ->
  tt.runtime.router = new tt.routers.MainRouter
  Backbone.history.start pushState: true

  tt.runtime.remoteDataHandler = new RemoteDataHander()