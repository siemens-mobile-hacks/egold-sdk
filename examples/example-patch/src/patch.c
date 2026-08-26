extern int strcmp(const char *s1, const char *s2);
extern char *strcpy(char *dst, const char *src);
extern char *strrchr(const char *s, int c);
extern int original_sys_open(char *path, unsigned int flags, unsigned int mode, unsigned int *err);

int sys_open_hook(char *path, unsigned int flags, unsigned int mode, unsigned int *err) {
	static const char flower[] = "Flower.gif";
	static const char tiger[] = "tiger5.gif";
	char redirected[128];
	char *name;
	unsigned int prefix;

	if (path != 0) {
		name = strrchr(path, '\\');
		if (name != 0) {
			name++;
		} else {
			name = path;
		}

		if (strcmp(name, flower) == 0) {
			prefix = name - path;
			if (prefix + sizeof(tiger) <= sizeof(redirected)) {
				strcpy(redirected, path);
				strcpy(redirected + prefix, tiger);
				path = redirected;
			}
		}
	}

	return original_sys_open(path, flags, mode, err);
}
