<?php

/*
 * This file is part of the LightSAML SP-Bundle package.
 *
 * (c) Milos Tomic <tmilos@lightsaml.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 */

namespace LightSaml\SpBundle\Security\User;

use LightSaml\Model\Assertion\Assertion;
use LightSaml\Model\Assertion\Attribute;
use LightSaml\Model\Assertion\AttributeStatement;
use LightSaml\Model\Protocol\Response;
use LightSaml\SpBundle\Security\Authentication\Token\SamlSpResponseToken;

class SimpleAttributeMapper implements AttributeMapperInterface
{
    public function getAttributes(Response $response): array
    {
        $assertions = $response->getAllAssertions();

        return array_reduce($assertions, [$this, 'resolveAttributesFromAssertion'], []);
    }

    private function resolveAttributesFromAssertion(array $attributes, Assertion $assertion): array
    {
        $attributeStatements = $assertion->getAllAttributeStatements();

        return array_reduce($attributeStatements, [$this, 'resolveAttributesFromAttributeStatement'], $attributes);
    }

    private function resolveAttributesFromAttributeStatement(array $attributes, AttributeStatement $attributeStatement): array
    {
        $statementAttributes = $attributeStatement->getAllAttributes();

        return array_reduce($statementAttributes, [$this, 'mapAttributeValues'], $attributes);
    }

    private function mapAttributeValues(array $attributes, Attribute $attribute): array
    {
        $key = $attribute->getName();
        $value = $attribute->getAllAttributeValues();

        if (!array_key_exists($key, $attributes) && 1 === count($value)) {
            $value = array_shift($value);
        }

        if (array_key_exists($key, $attributes)) {
            $currentValue = (is_array($attributes[$key]) ? $attributes[$key] : [$attributes[$key]]);

            $value = array_merge($currentValue, $value);
        }

        $attributes[$key] = $value;

        return $attributes;
    }
}
