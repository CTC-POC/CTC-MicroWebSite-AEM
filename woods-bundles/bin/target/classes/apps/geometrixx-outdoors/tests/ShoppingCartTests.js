
var cookieSetupTC = new hobs.TestCase("Setup Cart cookie before executing test case")
    .execSyncFct(function() {
        var cart = "ORDER%3A%3DorderId%3D5a99cc65-aebc-4144-8454-a181374dae5d%7CCART%3A%3Dquantity0%3D1%2CpromotionCount%3D0%2CvoucherCount%3D0%2Cproduct0%3D%2Fcontent%2Fgeometrixx-outdoors%2Fen%2Fmen%2Fshirts%2Fashanti-nomad%2Fjcr%3Acontent%2Fpar%2Fproduct%2Fmnapan-S%2CentryCount%3D1%7C|ORDER:=orderId%3d5e123a62-a870-4d90-9ace-870a1e19f4ac|CART:=quantity0%3d1%2cpromotionCount%3d0%2cvoucherCount%3d0%2cproduct0%3d%2fcontent%2fgeometrixx-outdoors%2fen%2fmen%2fshirts%2fashanti-nomad%2fjcr%3acontent%2fpar%2fproduct%2fmnapan-S%2centryCount%3d1|";
        $.cookie("CommercePersistence", cart, {path: "/"});
    });

new hobs.TestSuite("Geometrixx Outdoors - Shopping Cart Tests", {path:"/apps/geometrixx-outdoors/tests/ShoppingCartTests.js"})

    .addTestCase(new hobs.TestCase("Change quantity")
        .execTestCase(cookieSetupTC)
        .navigateTo("/content/geometrixx-outdoors/en/user/cart.html")
        .asserts.isTrue(function() {
            var prices = hobs.find(".entry .price");
            return prices.length == 1 && $(prices.get(0)).text() == "$29.50";
        })
        .fillInput(".entry .quantity input[name='quantity']", "2")
        .click(".entry .quantity input[type='submit']", {expectNav: true})
        .asserts.location("/content/geometrixx-outdoors/en/user/cart.html", true)
        .asserts.isTrue(function() {
            var prices = hobs.find(".entry .price");
            return prices.length == 1 && $(prices.get(0)).text() == "$59.00";
        })
    )

    .addTestCase(new hobs.TestCase("Remove item")
        .execTestCase(cookieSetupTC)
        .navigateTo("/content/geometrixx-outdoors/en/user/cart.html")
        .asserts.isTrue(function() {
            var prices = hobs.find(".entry .price");
            return prices.length == 1;
        })
        .click(".entry .delete input[type='submit']", {expectNav: true})
        .asserts.location("/content/geometrixx-outdoors/en/user/cart.html", true)
        .asserts.isTrue(function() {
            var prices = hobs.find(".entry .price");
            return prices.length == 0;
        })
    )

    .addTestCase(new hobs.TestCase("Add/remove coupon code")
        .execTestCase(cookieSetupTC)
        .navigateTo("/content/geometrixx-outdoors/en/user/cart.html")
        .asserts.isTrue(function() {
            var prices = hobs.find(".cq-cart-total.order.sub_total span");
            return prices.length == 1 && $(prices.get(0)).text() == "$29.50";
        })
        .sendKeys(".vouchers input[type='text']", "GIRLSKI", {delay: 2000})
        .click(".vouchers input[type='submit']", {expectNav: true})
        .asserts.location("/content/geometrixx-outdoors/en/user/cart.html", true)
        .asserts.isTrue(function() {
            var prices = hobs.find(".cq-cart-total.order.sub_total span");
            return prices.length == 1 && $(prices.get(0)).text() == "$19.50";
        })
        .click(".vouchers a")
        .asserts.location("/content/geometrixx-outdoors/en/user/cart.html", true)
        .asserts.isTrue(function() {
            var prices = hobs.find(".cq-cart-total.order.sub_total span");
            return prices.length == 1 && $(prices.get(0)).text() == "$29.50";
        })
    )

    .addTestCase(new hobs.TestCase("Validate cookie price insensitivity")
        .execSyncFct(function() {
            var cart = "ORDER:=orderId%3dc026bb4e-e0b9-4fb5-a875-72b122e41d75|CART:=price0%3d1.50%2cquantity0%3d1%2cpromotionCount%3d0%2cvoucherCount%3d0%2cproduct0%3d%2fcontent%2fgeometrixx-outdoors%2fen%2fmen%2fshirts%2fashanti-nomad%2fjcr%3acontent%2fpar%2fproduct%2fmnapan-S%2centryCount%3d1|";
            $.cookie("CommercePersistence", cart, {path: "/"});
        })
        .navigateTo("/content/geometrixx-outdoors/en/user/cart.html")
        .asserts.isTrue(function() {
            var prices = hobs.find(".entry .price");
            // Validate that the lower price is ignored:
            return $(prices.get(0)).text() == "$29.50";
        })
    );
