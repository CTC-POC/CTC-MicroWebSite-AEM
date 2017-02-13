new hobs.TestSuite("Geometrixx Outdoors - Product Page Tests", {path:"/apps/geometrixx-outdoors/tests/ProductPageTests.js", register: true})

    .addTestCase(new hobs.TestCase("Navigate to product page")
        .navigateTo("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html")
        .asserts.location("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html", true)
        .asserts.hasCssClass("article.product[data-sku='mnapjs.1-S']", "isHidden", false)
        .asserts.hasCssClass("article.product[data-sku='mnapjs.2-S']", "isHidden")
    )

    .addTestCase(new hobs.TestCase("Navigate to specific variation")
        .navigateTo("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html")
        .execSyncFct(function() {
            hobs.window.location.hash = "#mnapjs.2-M";
        })
        .reloadPage()
        .asserts.location("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html", true)
        .asserts.hasCssClass("article.product[data-sku='mnapjs.1-S']", "isHidden")
        .asserts.hasCssClass("article.product[data-sku='mnapjs.2-S']", "isHidden", false)
        .asserts.isTrue(function() {
            return hobs.find("input[name='product-size'][value='M']").closest("li").hasClass("selected");
        })
        .asserts.isFalse(function() {
            return hobs.find("input[name='product-size'][value='L']").closest("li").hasClass("selected");
        })
    )

    .addTestCase(new hobs.TestCase("Select variation")
        .navigateTo("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html")
        .asserts.hasCssClass("article.product[data-sku='mnapjs.1-S']", "isHidden", false)
        .asserts.hasCssClass(".product[data-sku='mnapjs.2-S']:has(input[name='product-size'][value='XL'])", "isHidden")
        .click("li[data-sku='mnapjs.2-S']")
        .asserts.hasCssClass("article.product[data-sku='mnapjs.1-S']", "isHidden")
        .asserts.hasCssClass("article.product[data-sku='mnapjs.2-S']", "isHidden", false)
        .asserts.hasCssClass(".product[data-sku='mnapjs.2-S']:has(input[name='product-size'][value='XL'])", "isHidden", false)
    )

    .addTestCase(new hobs.TestCase("Select size")
        .navigateTo("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html")
        .execSyncFct(function() {
            hobs.window.location.hash = "#mnapjs.2-M";
        })
        .reloadPage()
        .asserts.hasCssClass("article.product[data-sku='mnapjs.2-S']", "isHidden", false)
        .asserts.isFalse(function() {
            return hobs.find("input[name='product-size'][value='XL']").closest("li").hasClass("selected");
        })
        .asserts.isTrue(function() {
            return $(hobs.find("p.product-price").get(0)).text() == "$47.00";
        })
        .execSyncFct(function() {
            hobs.find("input[name='product-size'][value='XL']").closest("li").click();
        })
        .asserts.isTrue(function() {
            return hobs.find("input[name='product-size'][value='XL']").closest("li").hasClass("selected");
        })
        .asserts.isTrue(function() {
            return hobs.find(".product[data-sku='mnapjs.2-S']:visible p.product-price").text() == "$51.00";
        })
    )

    .addTestCase(new hobs.TestCase("Add to cart")
        .navigateTo("/content/geometrixx-outdoors/en/men/shorts/jola-summer.html")
        .click("li[data-sku='mnapjs.2-S']")
        .click(".product[data-sku='mnapjs.2-S'] input[name='product-size'][value='XL']")
        .fillInput(".product[data-sku='mnapjs.2-S'] input[name='product-quantity']", "1")
        .click(".product[data-sku='mnapjs.2-S'] .product-submit input[type='submit']", {expectNav: true})
        .asserts.location("/content/geometrixx-outdoors/en/user/cart.html", true)
        .asserts.exists("a[href$='/content/geometrixx-outdoors/en/men/shorts/jola-summer.html#mnapjs.2-XL']")
    );

