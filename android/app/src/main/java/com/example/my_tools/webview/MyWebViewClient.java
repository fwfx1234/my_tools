package com.example.my_tools.webview;

import android.os.Build;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.RequiresApi;

public class MyWebViewClient extends WebViewClient {
    private static final String TAG = "MyWebViewClient";
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
        if (request.getUrl() != null) {
            Log.d(TAG, "shouldOverrideUrlLoading: " +request.getUrl().getScheme());
            return !request.getUrl().getScheme().startsWith("http");
        }
        return super.shouldOverrideUrlLoading(view, request);
    }
}
