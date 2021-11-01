from FreemakerInterfaceModule import FreemakerInterface
from console import Console
from file import File
from json_utils import JsonUtils
from runtime import Runtime

type Params {
  jsonFile:string
  inputPath:string
  outputPath:string
}

service ParseService( params:Params ) {
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

    readFile@File( { filename = params.jsonFile, format = "json" } )( json )
    getJsonString@JsonUtils( json.data )( request.data )

    request.input_path = params.inputPath;
    request.output_path = params.outputPath;
    
    println@Console( request )()

    Parse@FreemakerOutputPort( request )( response );
    println@Console( response.output )()
  }
}
