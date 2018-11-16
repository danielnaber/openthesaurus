package openthesaurus


class LocalAuthInterceptor {

    def authService

    LocalAuthInterceptor() {
        ['exportOxt', 'exportText'].each { match(controller: it) }
    }

    boolean before() {
        authService.localHostAuth(request)
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
