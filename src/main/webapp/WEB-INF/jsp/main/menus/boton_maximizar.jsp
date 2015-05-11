<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
	text:'<s:message code="app.maximizar" text="**Maximizar" />'
	,iconCls:'icon_max'
	,handler:function(){
		if(Ext.get("north").getHeight()<30){
			Ext.get("north").select("img").setDisplayed(true);
			Ext.get("north").setHeight(82);
			Ext.getCmp("west-panel").expand(false);
			this.setIconClass('icon_max');
			this.setText('<s:message code="app.maximizar" text="**Maximizar" />');
		}else{
			Ext.get("north").select("img").setDisplayed(false);
			Ext.get("north").setHeight(26);
			Ext.getCmp("west-panel").collapse(false);
			this.setIconClass('icon_min');
			this.setText('<s:message code="app.minimizar" text="**Minimizar" />');
		}
		app.viewport.doLayout();
		
	}
})