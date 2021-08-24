<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <!-- CSRF Token -->
    <meta name="_token" content="{{ csrf_token() }}">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta http-equiv="Content-Security-Policy" content="block-all-mixed-content">
    <meta name="facebook-domain-verification" content="at5k4diviqkcx2zjknb5lq23ilwa0u" />
    <meta property="fb:pages" content="106214948192013" />
    <meta name="description" content="Toanchet-Market, join global market , Call : 010 500 313">

    <title>{{ config('app.name', 'Toanchet-Market') }}</title>
    <link rel="shortcut icon" href="{{ URL::asset('admin/image/logo_icon.ico') }}">


    <!-- Admin Page -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/fontawesome-free/css/all.min.css') }}">
    <link rel="stylesheet" href="{{ URL::asset('admin/dist/css/adminlte.min.css') }}">
    <!-- Select2 -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/select2/css/select2.min.css') }}">
    <link rel="stylesheet"
        href="{{ URL::asset('admin/plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css') }}">

    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/icheck-bootstrap/icheck-bootstrap.min.css') }}">
    <!-- Combobox select -->
    <link rel="stylesheet" href="{{ URL::asset('admin/select/css/bootstrap-select.css') }}">

    <!-- Fonts -->
    <link rel="dns-prefetch" href="//fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css?family=Nunito" rel="stylesheet">

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Google Font: Source Sans Pro -->
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <!-- jQuery CDN -->
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- Styles -->
    <style>
        /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */
        html {
            line-height: 1.15;
            -webkit-text-size-adjust: 100%
        }

        body {
            margin: 0
        }

        a {
            background-color: transparent
        }

        [hidden] {
            display: none
        }

        html {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji;
            line-height: 1.5
        }

        *,
        :after,
        :before {
            box-sizing: border-box;
            border: 0 solid #e2e8f0
        }

        a {
            color: inherit;
            text-decoration: inherit
        }

        svg,
        video {
            display: block;
            vertical-align: middle
        }

        video {
            max-width: 100%;
            height: auto
        }

        .bg-white {
            --bg-opacity: 1;
            background-color: #fff;
            background-color: rgba(255, 255, 255, var(--bg-opacity))
        }

        .bg-gray-100 {
            --bg-opacity: 1;
            background-color: #f7fafc;
            background-color: rgba(247, 250, 252, var(--bg-opacity))
        }

        .border-gray-200 {
            --border-opacity: 1;
            border-color: #edf2f7;
            border-color: rgba(237, 242, 247, var(--border-opacity))
        }

        .border-t {
            border-top-width: 1px
        }

        .flex {
            display: flex
        }

        .grid {
            display: grid
        }

        .hidden {
            display: none
        }

        .items-center {
            align-items: center
        }

        .justify-center {
            justify-content: center
        }

        .font-semibold {
            font-weight: 600
        }

        .h-5 {
            height: 1.25rem
        }

        .h-8 {
            height: 2rem
        }

        .h-16 {
            height: 4rem
        }

        .text-sm {
            font-size: .875rem
        }

        .text-lg {
            font-size: 1.125rem
        }

        .leading-7 {
            line-height: 1.75rem
        }

        .mx-auto {
            margin-left: auto;
            margin-right: auto
        }

        .ml-1 {
            margin-left: .25rem
        }

        .mt-2 {
            margin-top: .5rem
        }

        .mr-2 {
            margin-right: .5rem
        }

        .ml-2 {
            margin-left: .5rem
        }

        .mt-4 {
            margin-top: 1rem
        }

        .ml-4 {
            margin-left: 1rem
        }

        .mt-8 {
            margin-top: 2rem
        }

        .ml-12 {
            margin-left: 3rem
        }

        .-mt-px {
            margin-top: -1px
        }

        .max-w-6xl {
            max-width: 72rem
        }

        .min-h-screen {
            min-height: 100vh
        }

        .overflow-hidden {
            overflow: hidden
        }

        .p-6 {
            padding: 1.5rem
        }

        .py-4 {
            padding-top: 1rem;
            padding-bottom: 1rem
        }

        .px-6 {
            padding-left: 1.5rem;
            padding-right: 1.5rem
        }

        .pt-8 {
            padding-top: 2rem
        }

        .fixed {
            position: fixed
        }

        .relative {
            position: relative
        }

        .top-0 {
            top: 0
        }

        .right-0 {
            right: 0
        }

        .shadow {
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, .1), 0 1px 2px 0 rgba(0, 0, 0, .06)
        }

        .text-center {
            text-align: center
        }

        .text-gray-200 {
            --text-opacity: 1;
            color: #edf2f7;
            color: rgba(237, 242, 247, var(--text-opacity))
        }

        .text-gray-300 {
            --text-opacity: 1;
            color: #e2e8f0;
            color: rgba(226, 232, 240, var(--text-opacity))
        }

        .text-gray-400 {
            --text-opacity: 1;
            color: #cbd5e0;
            color: rgba(203, 213, 224, var(--text-opacity))
        }

        .text-gray-500 {
            --text-opacity: 1;
            color: #a0aec0;
            color: rgba(160, 174, 192, var(--text-opacity))
        }

        .text-gray-600 {
            --text-opacity: 1;
            color: #718096;
            color: rgba(113, 128, 150, var(--text-opacity))
        }

        .text-gray-700 {
            --text-opacity: 1;
            color: #4a5568;
            color: rgba(74, 85, 104, var(--text-opacity))
        }

        .text-gray-900 {
            --text-opacity: 1;
            color: #1a202c;
            color: rgba(26, 32, 44, var(--text-opacity))
        }

        .underline {
            text-decoration: underline
        }

        .antialiased {
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale
        }

        .w-5 {
            width: 1.25rem
        }

        .w-8 {
            width: 2rem
        }

        .w-auto {
            width: auto
        }

        .grid-cols-1 {
            grid-template-columns: repeat(1, minmax(0, 1fr))
        }

        @media (min-width:640px) {
            .sm\:rounded-lg {
                border-radius: .5rem
            }

            .sm\:block {
                display: block
            }

            .sm\:items-center {
                align-items: center
            }

            .sm\:justify-start {
                justify-content: flex-start
            }

            .sm\:justify-between {
                justify-content: space-between
            }

            .sm\:h-20 {
                height: 5rem
            }

            .sm\:ml-0 {
                margin-left: 0
            }

            .sm\:px-6 {
                padding-left: 1.5rem;
                padding-right: 1.5rem
            }

            .sm\:pt-0 {
                padding-top: 0
            }

            .sm\:text-left {
                text-align: left
            }

            .sm\:text-right {
                text-align: right
            }
        }

        @media (min-width:768px) {
            .md\:border-t-0 {
                border-top-width: 0
            }

            .md\:border-l {
                border-left-width: 1px
            }

            .md\:grid-cols-2 {
                grid-template-columns: repeat(2, minmax(0, 1fr))
            }
        }

        @media (min-width:1024px) {
            .lg\:px-8 {
                padding-left: 2rem;
                padding-right: 2rem
            }
        }

        @media (prefers-color-scheme:dark) {
            .dark\:bg-gray-800 {
                --bg-opacity: 1;
                background-color: #2d3748;
                background-color: rgba(45, 55, 72, var(--bg-opacity))
            }

            .dark\:bg-gray-900 {
                --bg-opacity: 1;
                background-color: #1a202c;
                background-color: rgba(26, 32, 44, var(--bg-opacity))
            }

            .dark\:border-gray-700 {
                --border-opacity: 1;
                border-color: #4a5568;
                border-color: rgba(74, 85, 104, var(--border-opacity))
            }

            .dark\:text-white {
                --text-opacity: 1;
                color: #fff;
                color: rgba(255, 255, 255, var(--text-opacity))
            }

            .dark\:text-gray-400 {
                --text-opacity: 1;
                color: #cbd5e0;
                color: rgba(203, 213, 224, var(--text-opacity))
            }
        }

    </style>
    <style>
        html,
        body {
            background-color: #fff;
            color: #636b6f;
            font-family: 'Nunito', sans-serif;
            font-weight: 200;
            height: 100vh;
            margin: 0;
        }

        .full-height {
            height: 40px;
        }

        .flex-center {
            align-items: center;
            display: flex;
            justify-content: center;
        }

        .position-ref {
            position: relative;
        }

        .top-right {
            position: absolute;
            right: 10px;
            top: 18px;
        }

        .content {
            text-align: center;
        }

        .title {
            font-size: 84px;
        }

        .links>a {
            color: #636b6f;
            padding: 0 25px;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: .1rem;
            text-decoration: none;
            text-transform: uppercase;
        }

        .m-b-md {
            margin-bottom: 30px;
        }

        /********************* shopping Demo-1 **********************/
        .product-grid {
            font-family: Raleway, sans-serif;
            text-align: center;
            padding: 0 0 72px;
            border: 1px solid rgba(0, 0, 0, .1);
            overflow: hidden;
            position: relative;
            z-index: 1
        }

        .product-grid .product-image {
            position: relative;
            transition: all .3s ease 0s
        }

        .product-grid .product-image a {
            display: block
        }

        .product-grid .product-image img {
            width: 100%;
            height: auto
        }

        .product-grid .pic-1 {
            opacity: 1;
            transition: all .3s ease-out 0s
        }

        .product-grid:hover .pic-1 {
            opacity: 1
        }

        .product-grid .pic-2 {
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            transition: all .3s ease-out 0s
        }

        .product-grid:hover .pic-2 {
            opacity: 1
        }

        .product-grid .social {
            width: 150px;
            padding: 0;
            margin: 0;
            list-style: none;
            opacity: 0;
            transform: translateY(-50%) translateX(-50%);
            position: absolute;
            top: 60%;
            left: 50%;
            z-index: 1;
            transition: all .3s ease 0s
        }

        .product-grid:hover .social {
            opacity: 1;
            top: 50%
        }

        .product-grid .social li {
            display: inline-block
        }

        .product-grid .social li a {
            color: #fff;
            background-color: #333;
            font-size: 16px;
            line-height: 40px;
            text-align: center;
            height: 40px;
            width: 40px;
            margin: 0 2px;
            display: block;
            position: relative;
            transition: all .3s ease-in-out
        }

        .product-grid .social li a:hover {
            color: #fff;
            background-color: #ef5777
        }

        .product-grid .social li a:after,
        .product-grid .social li a:before {
            content: attr(data-tip);
            color: #fff;
            background-color: #000;
            font-size: 12px;
            letter-spacing: 1px;
            line-height: 20px;
            padding: 1px 5px;
            white-space: nowrap;
            opacity: 0;
            transform: translateX(-50%);
            position: absolute;
            left: 50%;
            top: -30px
        }

        .product-grid .social li a:after {
            content: '';
            height: 15px;
            width: 15px;
            border-radius: 0;
            transform: translateX(-50%) rotate(45deg);
            top: -20px;
            z-index: -1
        }

        .product-grid .social li a:hover:after,
        .product-grid .social li a:hover:before {
            opacity: 1
        }

        .product-grid .product-discount-label,
        .product-grid .product-new-label {
            color: #fff;
            background-color: #ef5777;
            font-size: 12px;
            text-transform: uppercase;
            padding: 2px 7px;
            display: block;
            position: absolute;
            top: 10px;
            left: 0
        }

        .product-grid .product-discount-label {
            background-color: #333;
            left: auto;
            right: 0
        }

        .product-grid .rating {
            color: #FFD200;
            font-size: 12px;
            padding: 12px 0 0;
            margin: 0;
            list-style: none;
            position: relative;
            z-index: -1
        }

        .product-grid .rating li.disable {
            color: rgba(0, 0, 0, .2)
        }

        .product-grid .product-content {
            background-color: #fff;
            text-align: center;
            padding: 12px 0;
            margin: 0 auto;
            position: absolute;
            left: 0;
            right: 0;
            bottom: -27px;
            z-index: 1;
            transition: all .3s
        }

        .product-grid:hover .product-content {
            bottom: 0
        }

        .product-grid .title {
            font-size: 13px;
            font-weight: 400;
            letter-spacing: .5px;
            text-transform: capitalize;
            margin: 0 0 10px;
            transition: all .3s ease 0s
        }

        .product-grid .title a {
            color: #828282
        }

        .product-grid .title a:hover,
        .product-grid:hover .title a {
            color: #ef5777
        }

        .product-grid .price {
            color: #333;
            font-size: 17px;
            font-family: Montserrat, sans-serif;
            font-weight: 700;
            letter-spacing: .6px;
            margin-bottom: 8px;
            text-align: center;
            transition: all .3s
        }

        .product-grid .price span {
            color: #ef5777;
            font-size: 13px;
            font-weight: 400;
            text-decoration: line-through;
            margin-left: 3px;
            margin-bottom: 10px;
            display: inline-block
        }

        .product-grid .add-to-cart {
            color: #000;
            font-size: 13px;
            font-weight: 600
        }

        @media only screen and (max-width:990px) {
            .product-grid {
                margin-bottom: 30px
            }
        }

    </style>

</head>

<body>
    <div class="flex-center position-ref full-height">
        @if (Route::has('login'))
            <div class="top-right links">
                @auth
                    <a href="{{ url('/home') }}" class="text-sm text-gray-700 underline">Home</a>
                @else
                    <a href="{{ route('login') }}" class="text-sm text-gray-700 underline">Log in</a>


                    @if (Route::has('register'))
                        <a href="{{ route('register') }}" class="ml-4 text-sm text-gray-700 underline">Register</a>
                    @endif
                @endauth
            </div>
        @endif
    </div>
    <div class="wrapper">
        <div class="container">

            <h3 class="h3">Shopping</h3>
            <div class="row">
                <div class="col-md-3 col-sm-6">
                    <div class="product-grid">
                        <div class="product-image">
                            <a href="#">
                                <img class="pic-1"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-1.jpg">
                                <img class="pic-2"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-2.jpg">
                            </a>
                            <ul class="social">
                                <li><a href="" data-tip="Quick View"><i class="fa fa-search"></i></a></li>
                            </ul>
                            <span class="product-new-label">Sale</span>
                            <span class="product-discount-label">20%</span>
                        </div>
                        <ul class="rating">
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star disable"></li>
                        </ul>
                        <div class="product-content">
                            <h3 class="title"><a href="#">Keyboard</a></h3>
                            <div class="price">$16.00
                                <span>$20.00</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="product-grid">
                        <div class="product-image">
                            <a href="#">
                                <img class="pic-1"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-3.jpg">
                                <img class="pic-2"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-4.jpg">
                            </a>
                            <ul class="social">
                                <li><a href="" data-tip="Quick View"><i class="fa fa-search"></i></a></li>
                                <li><a href="" data-tip="Add to Wishlist"><i class="fa fa-shopping-bag"></i></a></li>
                                <li><a href="" data-tip="Add to Cart"><i class="fa fa-shopping-cart"></i></a></li>
                            </ul>
                            <span class="product-new-label">Sale</span>
                            <span class="product-discount-label">50%</span>
                        </div>
                        <ul class="rating">
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                        </ul>
                        <div class="product-content">
                            <h3 class="title"><a href="#">USB </a></h3>
                            <div class="price">$5.00
                                <span>$10.00</span>
                            </div>
                            <br />
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="product-grid">
                        <div class="product-image">
                            <a href="#">
                                <img class="pic-1"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-5.jpg">
                                <img class="pic-2"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-6.jpg">
                            </a>
                            <ul class="social">
                                <li><a href="" data-tip="Quick View"><i class="fa fa-search"></i></a></li>
                                <li><a href="" data-tip="Add to Wishlist"><i class="fa fa-shopping-bag"></i></a></li>
                                <li><a href="" data-tip="Add to Cart"><i class="fa fa-shopping-cart"></i></a></li>
                            </ul>
                            <span class="product-new-label">Sale</span>
                            <span class="product-discount-label">50%</span>
                        </div>
                        <ul class="rating">
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                        </ul>
                        <div class="product-content">
                            <h3 class="title"><a href="#">Computer</a></h3>
                            <div class="price">$5.00
                                <span>$10.00</span>
                            </div>
                            <br />
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="product-grid">
                        <div class="product-image">
                            <a href="#">
                                <img class="pic-1"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-7.jpg">
                                <img class="pic-2"
                                    src="http://bestjquery.com/tutorial/product-grid/demo9/images/img-8.jpg">
                            </a>
                            <ul class="social">
                                <li><a href="" data-tip="Quick View"><i class="fa fa-search"></i></a></li>
                                <li><a href="" data-tip="Add to Wishlist"><i class="fa fa-shopping-bag"></i></a></li>
                                <li><a href="" data-tip="Add to Cart"><i class="fa fa-shopping-cart"></i></a></li>
                            </ul>
                            <span class="product-new-label">Sale</span>
                            <span class="product-discount-label">50%</span>
                        </div>
                        <ul class="rating">
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                            <li class="fa fa-star"></li>
                        </ul>
                        <div class="product-content">
                            <h3 class="title"><a href="#">Accessory</a></h3>
                            <div class="price">$5.00
                                <span>$10.00</span>
                            </div>
                            <br />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>

</html>
