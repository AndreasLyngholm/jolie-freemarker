from FreemarkerInterfaceModule import FreemarkerInterface
from FreemarkerWebInterfaceModule import FreemarkerWebInterface
from console import Console
from file import File
from json_utils import JsonUtils
from runtime import Runtime

type Params {
  inputPath:string
  outputPath:string
  globalData?:string
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

  define loadFreemarker {
    loadEmbeddedService@Runtime( {
        filepath = "dk.simpleconcept.freemarker.Freemarker"
        type = "Java"
      } )( FreemarkerOutputPort.location )
  }

  init {
    loadFreemarker

    if( is_defined( params.globalData ) ) {
      readFile@File( { filename = params.globalData, format = "json" } )( json )
      getJsonString@JsonUtils( json.data )( data )

      Load@FreemarkerOutputPort( { .data = data } )( response )

      println@Console( response.response )()
    }
  }

  main {
    
    [ parse( request )( result ) {
      // Loading JSON
      readFile@File( { filename = request.data, format = "json" } )( json )
      getJsonString@JsonUtils( json.data )( freemarker.data )

      // Setting input and output paths
      freemarker.input_path = params.inputPath
      freemarker.output_path = params.outputPath

      // Setting file
      freemarker.file = request.file

      Parse@FreemarkerOutputPort( freemarker )( response )

      result.response = response.response

      println@Console( result.response )()

    }]

  }
}
