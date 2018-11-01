package openthesaurus

class AdminAuthInterceptor {

    def authService

    AdminAuthInterceptor() {
        ['admin', 'adminSync', 'category', 'import', 'language',
         'level', 'linkType', 'synsetLink', 'termLevel', 'termLinkType',
         'thesaurusConfigurationEntry'
        ].each { match(controller: it) }

        match(controller: 'tag')
            .excludes(action: 'index')
            .excludes(action: 'list')

    }

    boolean before() {
        if(!authService.isAdmin(session)) {
            authService.storeParams(session, params)
            flash.message = "You must login with admin-rights to access this area."
            redirect(controller:'user', action:'login')
            return false
        }

        true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
