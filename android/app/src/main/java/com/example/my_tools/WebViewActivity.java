package com.example.my_tools;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;

import com.example.my_tools.webview.MyChromeClient;
import com.example.my_tools.webview.MyWebViewClient;

public class WebViewActivity extends AppCompatActivity {
    private WebView webView;
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web_view);
        webView =  findViewById(R.id.webview);
        String url = getIntent().getExtras().getString("url","https://www.baidu.com");
        webView.loadUrl(url);
        webView.setWebContentsDebuggingEnabled(true);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setAllowContentAccess(true);
        settings.setAllowFileAccess(true);
        settings.setDomStorageEnabled(true);
        webView.setWebChromeClient(new MyChromeClient());
        webView.setWebViewClient(new MyWebViewClient());
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}