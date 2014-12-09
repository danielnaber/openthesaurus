import com.vionto.vithesaurus.Tag
import groovy.sql.Sql
import org.springframework.dao.DataIntegrityViolationException

class TagController extends BaseController {

    def beforeInterceptor = [action: this.&adminAuth, except: ['list']]

    def dataSource       // will be injected

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        def list = Tag.findAll()
        list.sort()
        LinkedHashMap nameToCount = new LinkedHashMap()
        def sql = new Sql(dataSource)
        sql.eachRow("select count(*) as mycount, tag.name from term_tag, tag where tag_id = tag.id group by tag_id order by mycount desc",
                { row -> nameToCount.put(row.name, row.mycount) })
        [tags: list, tagInstanceTotal: Tag.count(), nameToCount:nameToCount]
    }

    def detailList(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        [tagInstanceList: Tag.list(params), tagInstanceTotal: Tag.count()]
    }

    def create() {
        [tagInstance: new Tag(params)]
    }

    def save() {
        def tagInstance = new Tag(params)
        tagInstance.created = new Date()
        tagInstance.createdBy = session.user.realName
        if (!tagInstance.save(flush: true)) {
            render(view: "create", model: [tagInstance: tagInstance])
            return
        }
        flash.message = message(code: 'default.created.message', args: [message(code: 'tag.label', default: 'Tag'), tagInstance.id])
        redirect(action: "show", id: tagInstance.id)
    }

    def show(Long id) {
        def tagInstance = Tag.get(id)
        if (!tagInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "list")
            return
        }
        [tagInstance: tagInstance]
    }

    def edit(Long id) {
        def tagInstance = Tag.get(id)
        if (!tagInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "list")
            return
        }
        [tagInstance: tagInstance]
    }

    def update(Long id, Long version) {
        def tagInstance = Tag.get(id)
        if (!tagInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (tagInstance.version > version) {
                tagInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'tag.label', default: 'Tag')] as Object[],
                          "Another user has updated this Tag while you were editing")
                render(view: "edit", model: [tagInstance: tagInstance])
                return
            }
        }

        tagInstance.properties = params

        if (!tagInstance.save(flush: true)) {
            render(view: "edit", model: [tagInstance: tagInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'tag.label', default: 'Tag'), tagInstance.id])
        redirect(action: "show", id: tagInstance.id)
    }

    def delete(Long id) {
        def tagInstance = Tag.get(id)
        if (!tagInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "list")
            return
        }
        try {
            tagInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'tag.label', default: 'Tag'), id])
            redirect(action: "show", id: id)
        }
    }
}
