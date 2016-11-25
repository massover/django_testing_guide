GH_PAGES_SOURCES = docs dogs Makefile .nojekyll requirements.txt

html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs
	flake8 docs/conf.py

gh-pages:
    rm -rf /tmp/django_testing_guide
    cd /tmp
    git clone git@github.com:massover/django_testing_guide.git
    cd django_testing_guide
	git checkout gh-pages
	rm -rf ./*
	virtualenv --python=$(which python3) venv
	source venv/bin/activate
	pip install -r requirements.txt
	git checkout master $(GH_PAGES_SOURCES)
	git reset HEAD
	make html
	mv -fv docs/_build/html/* ./
	rm -rf $(GH_PAGES_SOURCES)
	git add -A
	git ci -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" \
		&& git push origin gh-pages \
		&& git checkout master