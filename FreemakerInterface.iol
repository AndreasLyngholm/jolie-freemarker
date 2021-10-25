type FreemakerRequest: void {
  input_path: string
  output_path: string
  data: string
}

type FreemakerResponse: void {
  response: string
}

interface FreemakerInterface {
  RequestResponse:
    Parse( FreemakerRequest )( FreemakerResponse )
}