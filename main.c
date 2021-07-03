#include <stdio.h>
#include <string.h>

#include "webview.h"
#include "fbrp/fbrp.h"
#include "haplous/haplous.h"

struct haplous_work work;
struct FbrpReference ref;
int err = 0;

webview_t w;

char *removeJS(char reference[]) {
	strtok(reference + 2, "\"]");
	return reference + 2;
}

void getVerses(const char *seq, const char *req, void *arg) {
	fbrp_parse(&ref, removeJS(req));
	char *text;
	struct haplous_reference href = {
		ref.book,
		ref.chapter[0].range[0],
		ref.verse[0].range[0] + 1,
		ref.verse[0].range[1] + 1
	};
	
	if (ref.verseLength == 0) {
		text = haplous_work_chapter_get(work.file, href, &err);
	} else {
		text = haplous_work_verses_get(work.file, href, &err);
	}

	// Remove last newline
	text[strlen(text) - 1] = 0;

	if (err != HAPLOUS_OK) {
		printf("Haplous err %d\n", err);
		exit(err);
	}

	char javascript[8192];
	snprintf(javascript, sizeof(javascript), "ret = `%s`;", text);

	free(text);

	webview_eval(w, javascript);
}

void loadTranslation(const char *seq, const char *req, void *arg) {
	work = haplous_work_init("kjv.txt", &err);
	if (err != HAPLOUS_OK) {
		puts("Haplous err");
		exit(0);
	}
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

	// Assume translation was loaded
	haplous_work_cleanup(&work);
	
	return 0;
}


