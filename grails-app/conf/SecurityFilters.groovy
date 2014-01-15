// keep logged-in users using HTTPS, idea taken from 
// http://stackoverflow.com/questions/7976973/grails-redirect-in-controller-switching-from-https-to-http-why
class SecurityFilters {

    def filters = {
        overall(controller: '*', action: '*') {
            after = {
                String loc = response.getHeader("Location")
                if (loc && !loc.contains("localhost:8080") && session.user) {
                    response.setHeader("Location", convertToHttps(loc))
                }
            }
        }
    }
    
    private String convertToHttps(String url) {
        return url.replaceFirst("http://", "https://")
    }
}
