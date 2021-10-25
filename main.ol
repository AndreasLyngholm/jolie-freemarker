include "FreemakerInterface.iol"
from console import Console
from file import File
from json_utils import JsonUtils

outputPort FreemakerOutputPort {
  Interfaces: FreemakerInterface
}

embedded {
  Java:
    "dk.simpleconcept.freemaker.Freemaker" in FreemakerOutputPort
}

service ParseService {
  embed File as File
  embed Console as Console
  embed JsonUtils as JsonUtils

  main {

      readFile@File( { filename = "data.json", format = "json" } )( json )
      getJsonString@JsonUtils( json.data )( request.data )

      request.input_path = "C:\\Coding\\thesis\\www";
      request.output_path = "C:\\Coding\\thesis\\www\\generated\\";
      
      println@Console( request )()

      Parse@FreemakerOutputPort( request )( response );
      println@Console( response.output )()
  }
}
