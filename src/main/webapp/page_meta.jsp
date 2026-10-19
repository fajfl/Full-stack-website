<%
    // 獲取頁面標題參數
    String pageTitle = request.getParameter("title");
    if (pageTitle == null) pageTitle = "";
    
    // 獲取頁面描述參數
    String pageDescription = request.getParameter("description");
    if (pageDescription == null) pageDescription = "中原第一家NBA球員卡專業商城，提供最優質的球員卡收藏品";
    
    // 獲取頁面關鍵字參數
    String pageKeywords = request.getParameter("keywords");
    if (pageKeywords == null) pageKeywords = "NBA,球員卡,籃球卡,收藏品,交易卡,運動卡片";
%>

<!-- 統一的meta標籤設定 -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="<%=pageDescription%>">
<meta name="keywords" content="<%=pageKeywords%>">
<meta name="author" content="NBA Card Team">
<meta name="robots" content="index, follow">
<meta name="language" content="zh-TW">

<!-- Open Graph 標籤 -->
<meta property="og:title" content="<%=pageTitle.isEmpty() ? "NBA卡包商城" : pageTitle + " - NBA卡包商城"%>">
<meta property="og:description" content="<%=pageDescription%>">
<meta property="og:type" content="website">
<meta property="og:locale" content="zh_TW">
<meta property="og:site_name" content="NBA卡包商城">
<meta property="og:image" content="<%=request.getContextPath()%>/images/nba-logo.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">

<!-- Twitter Card 標籤 -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="<%=pageTitle.isEmpty() ? "NBA卡包商城" : pageTitle + " - NBA卡包商城"%>">
<meta name="twitter:description" content="<%=pageDescription%>">
<meta name="twitter:image" content="<%=request.getContextPath()%>/images/nba-logo.png">

<!-- Favicon -->
<link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/images/favicon.ico">
<link rel="apple-touch-icon" sizes="180x180" href="<%=request.getContextPath()%>/images/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="<%=request.getContextPath()%>/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="<%=request.getContextPath()%>/images/favicon-16x16.png">

<!-- 頁面標題 -->
<title><%=pageTitle.isEmpty() ? "NBA卡包商城 - 中原第一家NBA球員卡專業商城" : pageTitle + " - NBA卡包商城"%></title>

<!-- CSS 引入 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@300;400;500;700;900&family=Roboto:wght@300;400;500;700;900&display=swap">

<!-- 性能優化 -->
<link rel="dns-prefetch" href="//fonts.googleapis.com">
<link rel="dns-prefetch" href="//cdnjs.cloudflare.com">

<!-- 主題顏色 -->
<meta name="theme-color" content="#003da5">
<meta name="msapplication-TileColor" content="#003da5">

<!-- 防止縮放 -->
<meta name="format-detection" content="telephone=no">

<!-- 安全設定 -->
<meta http-equiv="X-Content-Type-Options" content="nosniff">
<meta http-equiv="X-Frame-Options" content="DENY">
<meta http-equiv="X-XSS-Protection" content="1; mode=block"> 