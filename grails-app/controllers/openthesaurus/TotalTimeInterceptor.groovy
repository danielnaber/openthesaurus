package openthesaurus

class TotalTimeInterceptor {
    TotalTimeInterceptor() {
        matchAll()
    }

    boolean before() {
        request.startTime = System.currentTimeMillis()
        return true
    }

    boolean after() {
        //def totalTime = System.currentTimeMillis() - request.startTime
        //log.info("Total time for ${controllerName}.${actionName}: ${totalTime}ms")
        return true
    }

    void afterView() {
        //def totalTime = System.currentTimeMillis() - request.startTime
        //log.info("Total time for ${controllerName}.${actionName}: ${totalTime}ms - ${params.q}")
    }
}
