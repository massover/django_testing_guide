GH_PAGES_SOURCES = docs dogs Makefile .nojekyll requirements.txt
TEMP_DIR = /tmp/django_testing_guide

html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs
	flake8 docs/conf.py

gh-pages:
	rm -rfv $TEMP_DIR
	git clone git@github.com:massover/django_testing_guide.git /tmp/django_testing_guide
	cd $TEMP_DIR && git checkout gh-pages
	cd $TEMP_DIR && rm -rf ./*
	cd $TEMP_DIR && virtualenv --python=$(which python3) venv
	cd $TEMP_DIR && source venv/bin/activate
	cd $TEMP_DIR && pip install -r requirements.txt
	cd $TEMP_DIR && git checkout master $(GH_PAGES_SOURCES)
	cd $TEMP_DIR && git reset HEAD
	cd $TEMP_DIR && make html
	cd $TEMP_DIR && mv -fv docs/_build/html/* ./
	cd $TEMP_DIR && rm -rf $(GH_PAGES_SOURCES)
	cd $TEMP_DIR && git add -A
	cd $TEMP_DIR \
	    && git ci -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" \
		&& git push origin gh-pages \
		&& git checkout master