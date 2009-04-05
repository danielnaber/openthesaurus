/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2009 vionto GmbH, www.vionto.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 
package com.vionto.vithesaurus;

/**
 * A user of this system.
 */
class ThesaurusUser {

    String userId
    String password
    String realName
    String permission
    Date creationDate
    Date lastLoginDate
    
    final static USER_PERM = "user"
    final static ADMIN_PERM = "admin"
    
    static constraints = {
        userId(length:6..100, unique:true)
        password(length:5..50)
        permission(inList:[USER_PERM, ADMIN_PERM])
        realName(nullable:true)
        lastLoginDate(nullable:true)
    }

    static mapping = {
        //id generator:'sequence', params:[sequence:'thesaurus_user_seq']
    }

    ThesaurusUser() {
        this.creationDate = new Date()
    }
    
    ThesaurusUser(String userId, String password, String permission) {
        this.userId = userId
        this.password = password
        this.permission = permission
        this.creationDate = new Date()
    }

    /** Return true if user has at least user permissions.
     */
    boolean hasUserPermissions() {
        return permission == USER_PERM || hasAdminPermissions()
    }

    /** Return true if user has admin permissions.
     */
    boolean hasAdminPermissions() {
        return permission == ADMIN_PERM
    }
    
    String toString() {
        return userId  
    }
    
}
