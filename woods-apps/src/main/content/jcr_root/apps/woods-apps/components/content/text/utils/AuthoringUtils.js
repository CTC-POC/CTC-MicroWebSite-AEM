
"use strict";

use(function () {
    var touchMode, classicMode, currentMode;
    
    var AuthoringUtils = {
            CONST: {
                PROP_COMPONENT_TITLE: "jcr:title",
                COMPONENT_DEFAULT_TITLE: "Component"                
            }
    };
    
    try {
        touchMode = Packages.com.day.cq.wcm.api.AuthoringUIMode.TOUCH;
        classicMode = Packages.com.day.cq.wcm.api.AuthoringUIMode.CLASSIC;
        currentMode = Packages.com.day.cq.wcm.api.AuthoringUIMode.fromRequest(request);
    } catch (e) {
        log.debug("Could not detect authoring mode! " + e);
    }
    
    AuthoringUtils.isTouch = touchMode && touchMode.equals(currentMode);
    
    AuthoringUtils.isClassic = classicMode && classicMode.equals(currentMode);
    
    AuthoringUtils.componentTitle = function () {
        if (typeof component != "undefined") {
            return component.getProperties().get(AuthoringUtils.CONST.PROP_COMPONENT_TITLE,
                    AuthoringUtils.CONST.COMPONENT_DEFAULT_TITLE);
        }
        return AuthoringUtils.CONST.COMPONENT_DEFAULT_TITLE;
    };
    
    return AuthoringUtils;
});
