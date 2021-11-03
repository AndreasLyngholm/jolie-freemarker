from FreemarkerInterfaceModule import FreemarkerInterface
from FreemarkerWebInterfaceModule import FreemarkerWebInterface
from console import Console
from file import File
from json_utils import JsonUtils
from string_utils import StringUtils
from runtime import Runtime

type Config {
  template:string
  data:string
  outputPath:string
  globalData?:string
}

service FreemarkerService( config: Config ) {

  execution: concurrent

  embed File as File
  embed Console as Console
  embed JsonUtils as JsonUtils
  embed StringUtils as StringUtils
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

    if( is_defined( config.globalData ) ) {
      readFile@File( { filename = config.globalData, format = "json" } )( json )
      getJsonString@JsonUtils( json.data )( data )

      Load@FreemarkerOutputPort( { .data = data } )( response )

      println@Console( response.response )()
    }
  }

  main {
    
    [ parse( request )( result ) {

      replaceFirst@StringUtils( request.file { regex = config.outputPath, replacement = "" } )( file_name )

      // Setting file
      parsing.file = config.template + file_name + ".tol"

      exists@File( parsing.file )( template_file_exists )
      if( template_file_exists ) {

        data_file = config.data + file_name + ".json"
        exists@File( data_file )( data_file_exists )

        if( data_file_exists ) {
          // Loading JSON
          readFile@File( { filename = data_file, format = "json" } )( json )
          getJsonString@JsonUtils( json.data )( parsing.data )
        }

        // Setting input and output paths
        parsing.input_path = config.template
        parsing.output_path = config.outputPath

        Parse@FreemarkerOutputPort( parsing )( response )

        result.response = response.response

        println@Console( result.response )()
      } else {
        result.response = "Template file not found."
        println@Console( result.response )()
      }
    }]

  }
}
