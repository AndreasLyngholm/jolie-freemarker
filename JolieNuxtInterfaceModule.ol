type RenderRequest: void {
  file: string
}

type RenderResponse: void {
  response: string
}

interface JolieNuxtInterface {
  RequestResponse:
    Render( RenderRequest )( RenderResponse )
}