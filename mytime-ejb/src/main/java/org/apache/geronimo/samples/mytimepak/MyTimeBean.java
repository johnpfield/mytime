/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 * 
 *       http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package org.apache.geronimo.samples.mytimepak;

import javax.ejb.Stateless;
import javax.ejb.EnterpriseBean;
import javax.ejb.SessionContext;
import javax.annotation.Resource;


@Stateless
public class MyTimeBean implements EnterpriseBean, MyTimeLocal {

	@Resource
	private SessionContext ctx;


	public SessionContext getSessionContext() {
		return this.ctx;
	}
	

	public void setSessionContext(SessionContext aCtx) {
		this.ctx = aCtx;
	}
	
    public String getTime(String dummy) {
        String s = new java.util.Date().toString();
        String s2 = s.concat(dummy);
        return s2;
    }

    public String getTimePrivate(String dummy) {
        String s = new java.util.Date().toString();
        String s2 = s.concat(dummy);
        return s2;
    }
}
