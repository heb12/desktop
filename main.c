#include <stdio.h>

#include "webview.h"

webview_t w;

void getVerses(const char *seq, const char *req, void *arg) {
	// Remove [""]
	char reference[256];
	strcpy(reference, req);
	strtok(reference + 2, "\"]");

	char javascript[512];
	sprintf(javascript, "ret = `%s\nTest1`;", reference + 2);

	webview_eval(w, javascript);
}

void loadTranslation(const char *seq, const char *req, void *arg) {
	
}

#ifdef WIN32
	int WINAPI WinMain(HINSTANCE hInt, HINSTANCE hPrevInst, LPSTR lpCmdLine, int nCmdShow) {
#else
	int main() {
#endif
	w = webview_create(0, NULL);
	webview_set_title(w, "Heb12");
	webview_set_size(w, 512, 512, WEBVIEW_HINT_NONE);

	webview_bind(w, "getVerses", getVerses, NULL);
	webview_bind(w, "loadTranslation", loadTranslation, NULL);

	webview_navigate(w, UIDIR);
	webview_run(w);
	webview_destroy(w);
	return 0;
}


