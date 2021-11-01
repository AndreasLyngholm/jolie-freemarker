from FreemarkerInterfaceModule import FreemarkerInterface
from FreemarkerWebInterfaceModule import FreemarkerWebInterface
from console import Console
from file import File
from json_utils import JsonUtils
from runtime import Runtime

type Params {
  inputPath:string
  outputPath:string
}

service FreemarkerService( params: Params ) {

  execution: concurrent

  embed File as File
  embed Console as Console
  embed JsonUtils as JsonUtils
  embed Runtime as Runtime

  inputPort FreemarkerWebPort {
     location: "socket://localhost:8000"
     protocol: http { format = "json" }
     interfaces: FreemarkerWebInterface
   }

  outputPort FreemarkerOutputPort {
    interfaces: FreemarkerInterface
  }

  main {
    
    [ parse( request )( result ) {

      loadEmbeddedService@Runtime( {
        filepath = "dk.simpleconcept.freemaker.Freemaker"
        type = "Java"
      } )( FreemarkerOutputPort.location )

      // Loading JSON
      readFile@File( { filename = request.data, format = "json" } )( json )
      getJsonString@JsonUtils( json.data )( freemarker.data )

      // Setting input and output paths
      freemarker.input_path = params.inputPath;
      freemarker.output_path = params.outputPath;

      // Setting file
      freemarker.file = request.file;

      Parse@FreemarkerOutputPort( freemarker )( response );

      result.response = response.response;

      println@Console( result.response )()

    }]

  }
}
