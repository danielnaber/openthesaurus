package openthesaurus

import grails.artefact.gsp.TagLibraryInvoker

class UserAuthInterceptor implements TagLibraryInvoker {

    def authService

    UserAuthInterceptor() {
        ['check', 'merge', 'suggest'
        ].each { match(controller: it) }

        def matcher = match(controller: 'synset')
        ['index', 'list', 'search', 'newSearch', 'oldSearch', 'edit',
         'statistics', 'createMemoryDatabase', 'refreshRemoteWordLists',
         'variation', 'substring', 'listBySize'
        ].each { matcher.excludes(action: it) }

        matcher = match(controller: 'term')
        ['edit', 'list', 'antonyms'
        ].each { matcher.excludes(action: it) }

        matcher = match(controller: 'user')
        ['login', 'register', 'doRegister', 'confirmRegistration',
         'lostPassword', 'requestPasswordReset', 'confirmPasswordReset',
         'resetPassword', 'profile'
        ].each { matcher.excludes(action: it) }
    }

    boolean before() {
        if (!session.user) {
            authService.storeParams(session, params)
            flash.message = message(code:'user.please.login')
            redirect(controller:'user', action:'login')
            return false
        }
        if (session.user.blocked) {
            flash.message = message(code:'user.please.login')
            log.warn("Denying access to blocked user ($user)")
            return false
        }

        true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
