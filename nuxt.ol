from JolieNuxtInterfaceModule import JolieNuxtInterface
from JolieNuxtWebInterfaceModule import JolieNuxtWebInterface
from runtime import Runtime
from file import File
from console import Console
from time import Time
from string_utils import StringUtils

service Nuxt {
    embed Runtime as Runtime
    embed File as file
    embed Console as Console
    embed StringUtils as StringUtils
    embed Time as Time

    inputPort JolieNuxtPort {
        location: "socket://localhost:8000"
        protocol: http { format = "json" }
        interfaces: JolieNuxtWebInterface
    }

    outputPort JolieNuxtOutputPort {
        interfaces: JolieNuxtInterface
    }

    define loadJolieNuxt {
        loadEmbeddedService@Runtime( {
            filepath = "dk.simpleconcept.jolienuxt.JolieNuxt"
            type = "Java"
        } )( JolieNuxtOutputPort.location )
    }

    init {
        loadJolieNuxt
    }

    main {
        [ render( request )( result ) {

            println@Console( request.file )()

            Render@JolieNuxtOutputPort( request )( response )

            println@Console( response )()

            result.response = response.response
        }]
    }
}