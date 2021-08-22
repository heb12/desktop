#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "webview.h"
#include "fbrp/fbrp.h"
#include "haplous/haplous.h"

#define HAPLOUS_ERR() \
	if (err != HAPLOUS_OK) { \
		printf("Haplous err %d\n", err); \
		exit(err); \
	}

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

	char javascript[1024 * 8];

	webview_eval(w, "ret = ``;");

	if (ref.verseLength == 0) {
		struct haplous_reference href = {
			ref.book,
			ref.chapter[0].range[0],
			0, 0
		};

		text = haplous_work_chapter_get(work.file, href, &err);
		text[strlen(text) - 1] = 0;
		snprintf(javascript, sizeof(javascript), "ret = `%s`;", text);
		webview_eval(w, javascript);
	} else {
		for (int v = 0; v < ref.verseLength; v++) {
			struct haplous_reference href = {
				ref.book,
				ref.chapter[0].range[0],
				ref.verse[v].range[0],
				ref.verse[v].range[1]
			};

			text = haplous_work_verses_get(work.file, href, &err);
			HAPLOUS_ERR()
			if (v == ref.verseLength - 1) {
				text[strlen(text) - 1] = 0;
			}

			snprintf(javascript, sizeof(javascript), "ret += `%s`;", text);
			webview_eval(w, javascript);

			free(text);
		}
	}

	HAPLOUS_ERR()

	webview_eval(w, "trigger = true;");
}

void loadTranslation(const char *seq, const char *req, void *arg) {
	work = haplous_work_init("kjv.txt", &err);
	if (err != HAPLOUS_OK) {
		puts("Haplous err");
		exit(0);
	}
}

void debug(const char *seq, const char *req, void *arg) {
	puts(req);
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
	webview_bind(w, "debug", debug, NULL);

	webview_navigate(w, UIDIR);
	webview_run(w);
	webview_destroy(w);

	// Assume translation was loaded
	haplous_work_cleanup(&work);
	
	return 0;
}

