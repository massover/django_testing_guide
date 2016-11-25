html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs
	flake8 docs/conf.py

publish:
	git checkout gh-pages
	rm -rf .
	touch .nojekyll
	git checkout master docs/_build/html
	mv ./docs/build/html/* ./
	rm -rf ./docs
	git add -A
	git commit -m "publishing updated docs..."
	git push origin gh-pages
	git checkout master