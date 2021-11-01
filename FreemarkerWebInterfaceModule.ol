type FreemarkerWebRequest: void {
  file: string
  data: string
}

type FreemarkerWebResponse: void {
  response: string
}

interface FreemarkerWebInterface {
  RequestResponse:
    parse( FreemarkerWebRequest )( FreemarkerWebResponse )
}