type FreemarkerRequest: void {
  file: string
  input_path: string
  output_path: string
  data: string
}

type FreemarkerResponse: void {
  response: string
}

interface FreemarkerInterface {
  RequestResponse:
    Parse( FreemarkerRequest )( FreemarkerResponse )
}