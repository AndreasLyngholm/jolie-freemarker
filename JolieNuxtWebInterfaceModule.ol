type RenderRequest: void {
  file: string
}

type RenderResponse: void {
  response: string
}

interface JolieNuxtWebInterface {
  RequestResponse:
    render( RenderRequest )( RenderResponse )
}