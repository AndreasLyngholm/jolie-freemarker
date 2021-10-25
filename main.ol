from FreemakerInterfaceModule import FreemakerInterface
from console import Console
from file import File
from json_utils import JsonUtils
from runtime import Runtime

service ParseService {
  embed File as File
  embed Console as Console
  embed JsonUtils as JsonUtils
  embed Runtime as Runtime

  outputPort FreemakerOutputPort {
    interfaces: FreemakerInterface
  }

  main {
    loadEmbeddedService@Runtime( {
        filepath = "dk.simpleconcept.freemaker.Freemaker"
        type = "Java"
    } )( FreemakerOutputPort.location )

    readFile@File( { filename = "data.json", format = "json" } )( json )
    getJsonString@JsonUtils( json.data )( request.data )

    request.input_path = "C:\\Coding\\thesis\\www";
    request.output_path = "C:\\Coding\\thesis\\www\\generated\\";
    
    println@Console( request )()

    Parse@FreemakerOutputPort( request )( response );
    println@Console( response.output )()
  }
}
