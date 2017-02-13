/*
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */
(function() {
    'use strict';

    function getPointer(id) {
        var elem = document.getElementById('pointer-' + id);
        if (!elem) {
            elem = document.createElement('div');
            elem.setAttribute('id', 'pointer-' + id);
            elem.className = 'pointer';
            document.body.appendChild(elem);
        }
        return elem;
    }

    function updatePointer(id, x, y, evt, delta) {
        if (!delta) {
            delta = 24;
        }
        var el = getPointer(id);
        el.style.left = (x - delta) + 'px';
        el.style.top = (y - delta) + 'px';
        el.style.display = '';
        el.innerHTML = '<span>id:' + id + ', x:' + x + ', y:' + y + ' (' + evt.type + ')</span>';

        if (('' + id).indexOf('touch-') === 0) {
            el.className = 'pointer touch';
        } else {
            el.className = 'pointer ';
        }
    }

    // pointer events
    function onPointerDown(e) {
        updatePointer(e.pointerId, e.clientX, e.clientY, e);
    }

    function onPointerMove(e) {
        updatePointer(e.pointerId, e.clientX, e.clientY, e);
    }

    function onPointerUp(e) {
        var el = getPointer(e.pointerId);
        el.style.display = 'none';
    }

    // touch events
    function onTouchStart(e) {
        var touchlist = e.changedTouches;
        for (var i = 0; i < touchlist.length; i++) {
            var t = touchlist[i];
            updatePointer('touch-' + t.identifier, t.clientX, t.clientY, e);
        }
    }

    function onTouchMove(e) {
        var touchlist = e.changedTouches;
        for (var i = 0; i < touchlist.length; i++) {
            var t = touchlist[i];
            updatePointer('touch-' + t.identifier, t.clientX, t.clientY, e);
        }
    }

    function onTouchEnd(e) {
        var touchlist = e.changedTouches;
        for (var i = 0; i < touchlist.length; i++) {
            var t = touchlist[i];
            var el = getPointer('touch-' + t.identifier);
            el.style.display = 'none';
        }
    }

    // mouse events
    function onMouseDown(e) {
        updatePointer('mouse', e.clientX, e.clientY, e, 12);
    }

    function onMouseMove(e) {
        updatePointer('mouse', e.clientX, e.clientY, e, 12);
    }

    function onMouseUp(e) {
        updatePointer('mouse', e.clientX, e.clientY, e, 12);
    }

    window.addEventListener('pointerdown', onPointerDown, false);
    window.addEventListener('pointermove', onPointerMove, false);
    window.addEventListener('pointerup', onPointerUp, false);
    window.addEventListener('pointercancel', onPointerUp, false);

    window.addEventListener('touchstart', onTouchStart, false);
    window.addEventListener('touchmove', onTouchMove, false);
    window.addEventListener('touchend', onTouchEnd, false);
    window.addEventListener('touchcancel', onTouchEnd, false);

    window.addEventListener('mousemove', onMouseMove, false);
    window.addEventListener('mousedown', onMouseDown, false);
    window.addEventListener('mouseup', onMouseUp, false);


}());
